import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/services/hive_service.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

class TokenDetailController extends GetxController {
  final transactions = [].obs;
  final token = Get.arguments['token'];
  final balance = Get.arguments['balance'];

  final hs = Get.find<HiveService>();
  final ws = Get.find<WalletService>();

  @override
  void onInit() {
    super.onInit();
    showTotal();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {}

  showTotal() {
    transactions.value = hs
        .getTransactions()
        .where((tx) =>
            tx?.token == token &&
            (tx?.from == ws.current.value?.address ||
                tx?.to == ws.current.value?.address))
        .toList();
  }

  showIn() {
    transactions.value = hs
        .getTransactions()
        .where(
            (tx) => tx?.token == token && (tx?.to == ws.current.value?.address))
        .toList();
  }

  showOut() {
    transactions.value = hs
        .getTransactions()
        .where((tx) =>
            tx?.token == token && (tx?.from == ws.current.value?.address))
        .toList();
  }
}
