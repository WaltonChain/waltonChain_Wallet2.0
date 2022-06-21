import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/services/blockchain_service.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

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

  final WalletService ws = Get.find();
  final BlockchainService bs = Get.find();

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

  void clickPlace() async {
    final w = ws.current.value;
    if (w == null) {
      return;
    } else {
      await bs.createBuyOrder(wallet: w, price: 0.1, amount: 100);
    }
  }

  void clickSell() async {
    // final w = ws.current.value;
    // if (w == null) {
    //   return;
    // } else {
    // await bs.createSellOrder(wallet: w, price: 0.1, amount: 100);
    // }

    // final valid = swapFormKey.currentState?.validate();
    // if (valid == true) {
    final wallet = ws.current.value!;
    // final amount = double.tryParse(sellWtaAmount.text) ?? 0.00;
    const amount = 100.0;

    EasyLoading.show(status: 'Checking Approve');
    final needApprove = await bs.sellNeedApprove(wallet, amount);
    EasyLoading.dismiss();

    if (needApprove) {
      Get.defaultDialog(
        title: 'Approve',
        content: const Text('Need Approve'),
        onConfirm: () async {
          EasyLoading.show(status: 'Approving...');
          await bs.approveSell(wallet: wallet, amount: amount);
          EasyLoading.showSuccess('Approved');

          EasyLoading.show(status: 'swapping...');
          // await bs.wtaToWtc(wallet: wallet, amount: amount);
          await bs.createSellOrder(wallet: wallet, price: 0.1, amount: 100);

          EasyLoading.showSuccess('swapped');
        },
        onCancel: () {},
      );
    } else {
      // EasyLoading.show(status: 'swapping...');
      // await bs.wtaToWtc(wallet: wallet, amount: amount);
      await bs.createSellOrder(wallet: wallet, price: 0.1, amount: 100);

      // EasyLoading.showSuccess('swapped');
    }

    // }
  }
}
