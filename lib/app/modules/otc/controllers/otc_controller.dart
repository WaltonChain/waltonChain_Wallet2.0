import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/services/blockchain_service.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

class OtcController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Buy WTA'),
    const Tab(text: 'Sell WTA'),
  ];
  late TabController tc;

  dynamic buyIds = [].obs;
  dynamic buyOrders = [].obs;

  dynamic sellIds = [].obs;
  dynamic sellOrders = [].obs;

  final WalletService ws = Get.find();
  final BlockchainService bs = Get.find();

  @override
  void onInit() async {
    super.onInit();
    tc = TabController(vsync: this, length: myTabs.length);
    final bl = await bs.buyList();
    buyIds.value = bl[0];
    buyOrders.value = bl[1][0].where((i) => i[4].toInt() == 0).toList();
    // print('OtcController buyOrders.value:($buyOrders)');
    final sl = await bs.sellList();
    sellIds.value = sl[0];
    sellOrders.value = sl[1][0].where((i) => i[4].toInt() == 0).toList();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  void clickBuy(int id, BigInt amount) async {
    // await bs.buy(wallet: ws.current.value!, id: id, amount: amount);
    await bs.sell(wallet: ws.current.value!, id: id);
  }
}
