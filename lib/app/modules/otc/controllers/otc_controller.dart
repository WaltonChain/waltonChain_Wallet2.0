import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/models/otc_order.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
import 'package:wtc_wallet_app/app/data/services/blockchain_service.dart';
import 'package:wtc_wallet_app/app/data/services/wallet_service.dart';
import 'package:wtc_wallet_app/app/modules/assets/controllers/assets_controller.dart';

class OtcController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Buy WTA'),
    const Tab(text: 'Sell WTA'),
  ];
  late TabController tc;

  var buyIds = [].obs;
  dynamic buyOrders = [].obs;

  dynamic sellIds = [].obs;
  dynamic sellOrders = [].obs;

  final WalletService ws = Get.find();
  final BlockchainService bs = Get.find();
  final ac = Get.find<AssetsController>();

  @override
  void onInit() async {
    super.onInit();
    tc = TabController(vsync: this, length: myTabs.length);
    getOrders();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  Future<void> getOrders() async {
    // buy orders
    final bl = await bs.buyList();
    final buyStatus = bl[1][0].map((i) => i[4].toInt() == 0).toList();
    debugPrint('bl[0] type:(${bl[0].runtimeType}) bl[0]:(${bl[0]}) ');
    buyIds.value = (bl[0] as List)
        .asMap()
        .entries
        .where((entry) {
          final i = entry.key;
          return buyStatus[i];
        })
        .map((i) => i.value)
        .toList();
    buyOrders.value = bl[1][0].where((i) => i[4].toInt() == 0).toList();
    // debugPrint('getOrders buyIds:($buyIds) buyOrders:($buyOrders)');
    // sell orders
    final sl = await bs.sellList();
    final sellStatus = sl[1][0].map((i) => i[4].toInt() == 0).toList();

    sellIds.value = (sl[0] as List)
        .asMap()
        .entries
        .where((entry) {
          final i = entry.key;
          return sellStatus[i];
        })
        .map((i) => i.value)
        .toList();
    sellOrders.value = sl[1][0].where((i) => i[4].toInt() == 0).toList();
    debugPrint('getOrders sellIds:($sellIds) sellOrders:($sellOrders)');
  }

  void clickDeal(OtcOrder order) async {
    final w = ws.current.value!;
    if (order.type == 'sell') {
      await bs.buy(
        wallet: w,
        id: order.id,
        amount: Utils.bigIntFromDouble(order.wtcAmount),
      );
    } else if (order.type == 'buy') {
      await bs.sell(wallet: w, id: order.id);
    }
  }

  Future<void> refreshOrders() async {
    await getOrders();
  }
}
