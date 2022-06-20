import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaceOrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    const Tab(text: 'Buy WTA'),
    const Tab(text: 'Sell WTA'),
  ];
  late TabController tc;

  GlobalKey<FormState> buyFormKey = GlobalKey<FormState>(debugLabel: 'buyWta');
  TextEditingController buyWtcPrice = TextEditingController();
  TextEditingController buyWtaAmount = TextEditingController();

  GlobalKey<FormState> sellFormKey =
      GlobalKey<FormState>(debugLabel: 'sellWta');
  TextEditingController sellWtcPrice = TextEditingController();
  TextEditingController sellWtaAmount = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    tc = TabController(vsync: this, length: tabs.length);
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
