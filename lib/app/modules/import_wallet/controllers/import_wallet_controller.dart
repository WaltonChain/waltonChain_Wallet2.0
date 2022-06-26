import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
import 'package:wtc_wallet_app/app/data/models/wallet.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/data/services/wallet_service.dart';

class ImportWalletController extends GetxController {
  GlobalKey<FormState> formKey =
      GlobalKey<FormState>(debugLabel: 'importWalletForm');

  TextEditingController paste = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController passConfirm = TextEditingController();

  final wc = Get.find<WalletService>();

  @override
  void onClose() {}

  clickImport() async {
    final valid = formKey.currentState?.validate();
    if (valid == true) {
      String words;
      String privateKey;
      String address;
      String keyStore;
      if (paste.text.contains(' ')) {
        words = paste.text;
        privateKey = await Utils.privateKeyFromWords(words);
        keyStore =
            Utils.keyStoreFromPrivateKey(privateKey, Utils.hash(pass.text));
        address = await Utils.addressFromPrivateKey(privateKey);
      } else {
        privateKey = paste.text;
        address = await Utils.addressFromPrivateKey(privateKey);
        words = Utils.randomWords();
        keyStore = Utils.keyStoreFromPrivateKey(
          privateKey,
          Utils.hash(pass.text),
        );
      }

      final imported = Wallet(
        name: name.text,
        pass: Utils.hash(pass.text),
        address: address,
        keyStore: keyStore,
      );

      await wc.add(imported);
      Get.offNamed(Routes.HOME);
    }
  }
}
