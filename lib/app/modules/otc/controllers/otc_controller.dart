import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtcController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Buy WTA'),
    const Tab(text: 'Sell WTA'),
  ];
  late TabController tc;

  @override
  void onInit() {
    super.onInit();
    tc = TabController(vsync: this, length: myTabs.length);
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

}
