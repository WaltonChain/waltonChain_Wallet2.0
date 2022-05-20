import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

class WalletDetailController extends GetxController {
  TextEditingController pass = TextEditingController();

  final wc = Get.find<WalletService>();

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {}

  tapAddress(wallet) async {
    await Clipboard.setData(ClipboardData(text: wallet.address));
    Get.snackbar('Copy Success', 'Address copied to clipboard');
  }

  clickDialogConfirm(wallet) {
    final inputHashed = Utils.hash(pass.text);
    final hashed = wallet.pass;
    if (inputHashed == hashed) {
      final ks = wallet.keyStore;
      final pk = Utils.privateKeyFromKeyStore(ks, hashed);
      // debugPrint('wallet detail view onConfirm pk:($pk)');
      pass.clear();
      Get.back();
      Utils.customDialog(
          title: 'privateKey',
          content: SelectableText(pk),
          onConfirm: () {
            Get.back();
          });
    } else {
      pass.clear();
      Get.back();
      Get.snackbar('Error', 'password error');
    }
  }

  confirmDelete(wallet) {
    wc.del(wallet);
  }
}
