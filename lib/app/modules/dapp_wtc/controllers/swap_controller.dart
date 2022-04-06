import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/models/blockchain.dart';
import 'package:wtc_wallet_app/app/modules/assets/controllers/assets_controller.dart';
import 'package:wtc_wallet_app/app/services/hive_service.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

class SwapController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Swap'),
    const Tab(text: 'Staking'),
  ];
  late TabController tc;

  final ac = Get.find<AssetsController>();
  final ws = Get.find<WalletService>();
  final hs = Get.find<HiveService>();

  var wtcBalance = 0.0000.obs;
  var wtaBalance = 0.0000.obs;
  final isWtcToWta = true.obs;

  GlobalKey<FormState> swapFormKey =
      GlobalKey<FormState>(debugLabel: 'swapForm');
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    tc = TabController(vsync: this, length: myTabs.length);
    wtcBalance.value = ac.wtcBalance.value;
    wtaBalance.value = ac.wtaBalance.value;

    from.addListener(() {
      final fromAmount = double.tryParse(from.text) ?? 0.0000;
      if (isWtcToWta.value) {
        // from.text = fromAmount.toStringAsFixed(4);
        to.text = (fromAmount * 10).toStringAsFixed(4);
      } else {
        // from.text = fromAmount.toStringAsFixed(4);
        to.text = (fromAmount / 10).toStringAsFixed(4);
      }
    });
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {
    tc.dispose();
    from.dispose();
    to.dispose();

    super.onClose();
  }

  clickSwitch() {
    isWtcToWta.value = !isWtcToWta.value;
    from.text = to.text;
  }

  clickSwap() async {
    final valid = swapFormKey.currentState?.validate();
    if (valid == true) {
      EasyLoading.show(status: 'swapping...');
      final pk = hs.getPrivateKey(ws.current.value?.address ?? '');
      if (isWtcToWta.value) {
        await Blockchain.wtcToWta(pk, from.text);
      } else {
        await Blockchain.wtaToWtc(pk, from.text);
      }
      EasyLoading.showSuccess('swapped');
    }
  }
}
