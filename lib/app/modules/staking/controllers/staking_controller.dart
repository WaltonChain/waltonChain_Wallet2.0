import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/services/blockchain_service.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

class StakingController extends GetxController {
  GlobalKey<FormState> stakingFormKey =
      GlobalKey<FormState>(debugLabel: 'stakingForm');
  TextEditingController stakingInput = TextEditingController();
  TextEditingController factorInput = TextEditingController();

  final ws = Get.find<WalletService>();
  final bs = Get.find<BlockchainService>();

  // 百分数
  final factors = [45, 100, 210, 330, 700];
  final days = [15, 30, 60, 90, 180];
  var index = 4.obs;

  @override
  void onInit() {
    super.onInit();
    factorInput.text = (factors[index.value] / 100).toStringAsFixed(2);
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {
    super.onClose();
    stakingInput.dispose();
  }

  void setIndex(int index) {
    this.index.value = index;
    factorInput.text = (factors[index] / 100).toStringAsFixed(2);
  }

  void clickConfirm() {
    final valid = stakingFormKey.currentState?.validate();
    if (valid == true) {
      final amount = double.tryParse(stakingInput.text) ?? 0.00;
      EasyLoading.show(status: 'withdrawing...');
      bs.newStake(
          wallet: ws.current.value!, amount: amount, periodIndex: index.value);
      EasyLoading.showSuccess('withdraw success');
    }
  }
}
