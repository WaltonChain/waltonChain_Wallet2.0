import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wtc_wallet_app/app/data/models/transaction.dart';
import 'package:wtc_wallet_app/app/modules/assets/controllers/assets_controller.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/data/services/blockchain_service.dart';
import 'package:wtc_wallet_app/app/data/services/storage/services.dart';
import 'package:wtc_wallet_app/app/data/services/wallet_service.dart';

class SendController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>(debugLabel: 'sendForm');
  TextEditingController addressInput = TextEditingController();
  TextEditingController balanceInput = TextEditingController();

  final token = 'wtc'.obs;
  final balance = 0.00.obs;
  final to = Get.arguments?['to'] ?? '';

  final ac = Get.find<AssetsController>();
  final ws = Get.find<WalletService>();
  final hs = Get.find<HiveService>();
  final bs = Get.find<BlockchainService>();

  @override
  void onInit() {
    super.onInit();
    balance.value = ac.wtcBalance.value;
    addressInput.text = to;

    ever(token, (newToken) {
      if (newToken == 'wtc') {
        balance.value = ac.wtcBalance.value;
      } else if (newToken == 'wta') {
        balance.value = ac.wtaBalance.value;
      } else {
        balance.value = 0.00;
      }
    });
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {}

  clickSwitch() {
    if (token.value == 'wtc') {
      token.value = 'wta';
    } else {
      token.value = 'wtc';
    }
  }

  clickSend() async {
    final valid = formKey.currentState?.validate();
    // final pk = await sss.getPrivateKey(ws.current.value?.address ?? '');
    // final pk = hs.getPrivateKey(ws.current.value?.address ?? '');
    if (valid == true) {
      final amount = double.parse(balanceInput.text);
      dynamic hash;
      if (token.value == 'wtc') {
        hash = await bs.transferWTC(
            wallet: ws.current.value!, to: addressInput.text, amount: amount);
        final time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        await Future.delayed(const Duration(minutes: 10));
        final r = await bs.getReceipt(hash);
        final transaction = Transaction(
          from: ws.current.value?.address ?? '',
          to: addressInput.text,
          hash: hash,
          time: time,
          amount: amount,
          token: 'wtc',
          status: r == null ? false : r.status,
        );
        hs.saveTransaction(transaction);
      } else if (token.value == 'wta') {
        hash = await bs.transferWTA(
            wallet: ws.current.value!, to: addressInput.text, amount: amount);
        final time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        await Future.delayed(const Duration(minutes: 10));
        final r = await bs.getReceipt(hash);
        final transaction = Transaction(
            from: ws.current.value?.address ?? '',
            to: addressInput.text,
            hash: hash,
            time: time,
            amount: amount,
            token: 'wta',
            status: r == null ? false : r.status);
        hs.saveTransaction(transaction);
      }

      Get.back();
    } else {
      Get.snackbar('validate false', 'please check your input');
    }
  }

  void clickScan() async {
    Get.offNamed(Routes.CAMERA_SCAN);
  }
}
