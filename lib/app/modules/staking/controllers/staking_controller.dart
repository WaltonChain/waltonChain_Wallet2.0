import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StakingController extends GetxController {
  GlobalKey<FormState> stakingFormKey =
      GlobalKey<FormState>(debugLabel: 'stakingForm');
  TextEditingController stakingInput = TextEditingController();
  TextEditingController factorInput = TextEditingController();

  final days = [15, 30, 60, 90, 180];
  var index = 4.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  // }

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
  }

  void clickConfirm() {}
}
