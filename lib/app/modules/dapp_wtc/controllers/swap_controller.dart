import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/modules/assets/controllers/assets_controller.dart';
import 'package:wtc_wallet_app/app/services/blockchain_service.dart';
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
  final bs = Get.find<BlockchainService>();

  var wtcBalance = 0.00.obs;
  var wtaBalance = 0.00.obs;
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
      final fromAmount = double.tryParse(from.text) ?? 0.00;
      if (isWtcToWta.value) {
        // from.text = fromAmount.toStringAsFixed(2);
        to.text = (fromAmount * 10).toStringAsFixed(2);
      } else {
        // from.text = fromAmount.toStringAsFixed(2);
        to.text = (fromAmount / 10).toStringAsFixed(2);
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
    Get.snackbar('Comming Soon', "Can't available now");
    // final valid = swapFormKey.currentState?.validate();
    // if (valid == true) {
    //   final wallet = ws.current.value!;
    //   final amount = double.tryParse(from.text) ?? 0.00;
    //   if (isWtcToWta.value) {
    //     EasyLoading.show(status: 'swapping...');
    //     await bs.wtcToWta(wallet: wallet, amount: amount);
    //     EasyLoading.showSuccess('swapped');
    //   } else {
    //     EasyLoading.show(status: 'Checking Approve');
    //     final needApprove = await bs.needApprove(wallet, amount);
    //     EasyLoading.dismiss();

    //     if (needApprove) {
    //       Get.defaultDialog(
    //         title: 'Approve',
    //         content: const Text('Need Approve'),
    //         onConfirm: () async {
    //           EasyLoading.show(status: 'Approving...');
    //           await bs.approveSwap(wallet: wallet, amount: amount);
    //           EasyLoading.showSuccess('Approved');

    //           EasyLoading.show(status: 'swapping...');
    //           await bs.wtaToWtc(wallet: wallet, amount: amount);
    //           EasyLoading.showSuccess('swapped');
    //         },
    //         onCancel: () {},
    //       );
    //     } else {
    //       EasyLoading.show(status: 'swapping...');
    //       await bs.wtaToWtc(wallet: wallet, amount: amount);
    //       EasyLoading.showSuccess('swapped');
    //     }
    //   }
    // }
  }
}
