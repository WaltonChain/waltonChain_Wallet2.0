import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
import 'package:wtc_wallet_app/app/data/models/wallet.dart';
import 'package:wtc_wallet_app/app/modules/create_wallet/views/backup_wallet_view.dart';
import 'package:wtc_wallet_app/app/modules/create_wallet/views/backup_words_view.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

class CreateWalletController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController passConfirm = TextEditingController();

  final wc = Get.find<WalletService>();

  final words = ''.obs;
  var privateKey = '';
  var address = '';
  var keyStoreStr = '';

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {
    name.dispose();
    pass.dispose();
    passConfirm.dispose();
    super.dispose();
  }

  clickCreate() async {
    final valid = formKey.currentState!.validate();
    if (valid == true) {
      words.value = Utils.randomWords();
      privateKey = await Utils.privateKeyFromWords(words.value);
      keyStoreStr = Utils.keyStoreFromPrivateKey(
        privateKey,
        Utils.hash(pass.text),
      );
      address = await Utils.addressFromPrivateKey(privateKey);
      Get.to(() => const BackupWallet());
    }
  }

  clickNext() {
    // words.value = Utils.randomWords();
    Get.to(() => const BackupWordsView());
  }

  clickCopy() async {
    await Clipboard.setData(ClipboardData(text: words.value));

    wc.add(Wallet.fromJson({
      'name': name.text,
      'pass': Utils.hash(pass.text),
      'address': address,
      'keyStore': keyStoreStr,
    }));

    Get.offAllNamed(Routes.HOME);
    Get.snackbar('COPY', 'Success');
  }
}
