import 'package:flutter/material.dart';
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

  final buyPrice = 0.0.obs;
  final sellPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    tc = TabController(vsync: this, length: tabs.length);
    buyWtcPrice.addListener(() {
      final wtcAmount = double.tryParse(buyWtcPrice.text) ?? 0.0;
      final wtaAmount = double.tryParse(buyWtaAmount.text) ?? 0.0;
      if (wtcAmount != 0.0 && wtaAmount != 0.0) {
        buyPrice.value = wtaAmount / wtcAmount;
      } else {
        buyPrice.value = 0.0;
      }
    });
    buyWtaAmount.addListener(() {
      final wtcAmount = double.tryParse(buyWtcPrice.text) ?? 0.0;
      final wtaAmount = double.tryParse(buyWtaAmount.text) ?? 0.0;
      if (wtcAmount != 0.0 && wtaAmount != 0.0) {
        buyPrice.value = wtaAmount / wtcAmount;
      } else {
        buyPrice.value = 0.0;
      }
    });
    sellWtcPrice.addListener(() {
      final wtcAmount = double.tryParse(sellWtcPrice.text) ?? 0.0;
      final wtaAmount = double.tryParse(sellWtaAmount.text) ?? 0.0;
      if (wtcAmount != 0.0 && wtaAmount != 0.0) {
        sellPrice.value = wtaAmount / wtcAmount;
      } else {
        sellPrice.value = 0.0;
      }
    });
    sellWtaAmount.addListener(() {
      final wtcAmount = double.tryParse(sellWtcPrice.text) ?? 0.0;
      final wtaAmount = double.tryParse(sellWtaAmount.text) ?? 0.0;
      if (wtcAmount != 0.0 && wtaAmount != 0.0) {
        sellPrice.value = wtaAmount / wtcAmount;
      } else {
        sellPrice.value = 0.0;
      }
    });
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  void clickPlaceBuy() async {
    final valid = buyFormKey.currentState?.validate();
    if (valid == true) {
      await bs.createBuyOrder(
        wallet: ws.current.value!,
        wtaAmount: double.parse(buyWtaAmount.text),
        wtcAmount: double.parse(buyWtcPrice.text),
      );
    } else {
      Get.snackbar('Fail', 'Validate Fail');
    }
  }

  void clickPlaceSell() async {
    final valid = sellFormKey.currentState?.validate();
    if (valid == true) {
      final wallet = ws.current.value!;
      final amount = double.tryParse(sellWtaAmount.text) ?? 0.00;

      final needApprove = await bs.sellNeedApprove(wallet, amount);

      if (needApprove) {
        Get.defaultDialog(
          title: 'Approve',
          content: const Text('Need Approve'),
          onConfirm: () async {
            await bs.approveSell(wallet: wallet, amount: amount);
            await bs.createSellOrder(
              wallet: wallet,
              wtaAmount: double.parse(sellWtaAmount.text),
              wtcAmount: double.parse(sellWtcPrice.text),
            );
          },
          onCancel: () {
            Get.back();
          },
        );
      } else {
        await bs.createSellOrder(
          wallet: wallet,
          wtaAmount: double.parse(sellWtaAmount.text),
          wtcAmount: double.parse(sellWtcPrice.text),
        );
      }
    } else {
      Get.snackbar('Fail', 'Validate Fail');
    }
  }
}
