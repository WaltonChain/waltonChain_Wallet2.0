import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/modules/assets/controllers/assets_controller.dart';
import 'package:wtc_wallet_app/app/services/blockchain_service.dart';
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
  final bs = Get.find<BlockchainService>();

  var tvl = 0.00.obs;
  var apr = 0.00.obs;
  var balance = 0.00.obs;
  var staked = 0.00.obs;
  var profit = 0.00.obs;

  @override
  void onInit() async {
    super.onInit();
    setTvlAndApr();
    balance.value = ac.wtcBalance.value;
    staked.value = await bs.getStaked(ws.current.value!);
    profit.value = await bs.getRewarded(ws.current.value!);

    Timer.periodic(const Duration(seconds: 30), (timer) async {
      profit.value = await bs.getRewarded(ws.current.value!);
    });
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {}

  setTvlAndApr() async {
    final totalSupply = await bs.getTotalSupply();
    final t = totalSupply * ac.wtcPrice.value;
    tvl.value = t;
    final a = 2000 * 365 / totalSupply * 100;
    apr.value = a;
  }

  clickStake() async {
    final valid = stakeFormKey.currentState?.validate();
    if (valid == true) {
      final amount = double.tryParse(stakeInput.text) ?? 0.00;
      EasyLoading.show(status: 'staking...');
      await bs.stake(wallet: ws.current.value!, amount: amount);
      EasyLoading.showSuccess('stake success');
    }
  }

  clickWithdrawWtc() async {
    final valid = withdrawFormKey.currentState?.validate();
    if (valid == true) {
      final amount = double.tryParse(withdrawInput.text) ?? 0.00;
      EasyLoading.show(status: 'withdrawing...');
      await bs.withdrawWtc(wallet: ws.current.value!, amount: amount);
      EasyLoading.showSuccess('withdraw success');
    }
  }

  clickWithdrawProfit() async {
    EasyLoading.show(status: 'Harvesting');
    await bs.withdrawReward(ws.current.value!);
    EasyLoading.showSuccess('Harvest Success');
  }
}
