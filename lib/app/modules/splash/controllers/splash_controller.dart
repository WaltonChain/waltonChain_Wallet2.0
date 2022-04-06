import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

class SplashController extends GetxController {
  // var wallets = [].obs;
  final wc = Get.find<WalletService>();
  @override
  void onInit() {
    super.onInit();

    try {
      // wallets.value = Hive.box('db').get('wallets');

    } catch (e) {
      debugPrint(e.toString());
    }

    // debugPrint('SplashController onInit wallets:($wallets)');
  }

  @override
  void onReady() {
    super.onReady();

    if (wc.wallets.isEmpty) {
      Get.offNamed(Routes.CREATE_WALLET);
    } else {
      Get.offNamed(Routes.HOME);
    }
  }

  @override
  void onClose() {}
}
