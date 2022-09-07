// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/services/storage/services.dart';
import 'package:wtc_wallet_app/app/data/services/wallet_service.dart';

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
    final r = hs
        .getTransactions()
        .where((tx) =>
            tx?.token == token &&
            (tx?.from == ws.current.value?.address ||
                tx?.to == ws.current.value?.address))
        .toList();
    r.sort((a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
    transactions.value = r;
  }

  showIn() {
    final r = hs
        .getTransactions()
        .where(
            (tx) => tx?.token == token && (tx?.to == ws.current.value?.address))
        .toList();
    r.sort((a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
    transactions.value = r;
  }

  showOut() {
    final r = hs
        .getTransactions()
        .where((tx) =>
            tx?.token == token && (tx?.from == ws.current.value?.address))
        .toList();
    r.sort((a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
    transactions.value = r;
  }
}
