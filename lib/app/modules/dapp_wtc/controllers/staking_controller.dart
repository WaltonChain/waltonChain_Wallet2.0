import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/models/blockchain.dart';
import 'package:wtc_wallet_app/app/modules/assets/controllers/assets_controller.dart';
import 'package:wtc_wallet_app/app/services/hive_service.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

class StakingController extends GetxController {
  GlobalKey<FormState> stakeFormKey =
      GlobalKey<FormState>(debugLabel: 'stakeForm');
  GlobalKey<FormState> withdrawFormKey =
      GlobalKey<FormState>(debugLabel: 'withdrawForm');
  TextEditingController stakeInput = TextEditingController();
  TextEditingController withdrawInput = TextEditingController();

  final ac = Get.find<AssetsController>();
  final ws = Get.find<WalletService>();
  final hs = Get.find<HiveService>();

  var tvl = 0.0000.obs;
  var apr = 0.0000.obs;
  var balance = 0.0000.obs;
  var staked = 0.0000.obs;
  var profit = 0.0000.obs;

  @override
  void onInit() async {
    super.onInit();
    tvl.value = await Blockchain.getTvl(ac.wtcPrice.value);
    apr.value = await Blockchain.getApr();
    balance.value = ac.wtcBalance.value;
    staked.value = await Blockchain.getStaked(ws.current.value?.address ?? '');
    profit.value =
        await Blockchain.showRewards(ws.current.value?.address ?? '');

    Timer.periodic(const Duration(seconds: 30), (timer) async {
      profit.value =
          await Blockchain.showRewards(ws.current.value?.address ?? '');
    });
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {}

  clickStake() async {
    final valid = stakeFormKey.currentState?.validate();
    if (valid == true) {
      final pk = hs.getPrivateKey(ws.current.value?.address ?? '');
      EasyLoading.show(status: 'staking...');
      await Blockchain.stake(pk, stakeInput.text);
      EasyLoading.showSuccess('stake success');
    }
  }

  clickWithdrawWtc() async {
    final valid = withdrawFormKey.currentState?.validate();
    if (valid == true) {
      final pk = hs.getPrivateKey(ws.current.value?.address ?? '');
      EasyLoading.show(status: 'withdrawing...');
      await Blockchain.withdrawWtc(pk, withdrawInput.text);
      EasyLoading.showSuccess('withdraw success');
    }
  }

  clickWithdrawProfit() async {
    final pk = hs.getPrivateKey(ws.current.value?.address ?? '');
    EasyLoading.show(status: 'getting rewards...');
    await Blockchain.getReward(pk);
    EasyLoading.showSuccess('get rewards success');
  }
}
