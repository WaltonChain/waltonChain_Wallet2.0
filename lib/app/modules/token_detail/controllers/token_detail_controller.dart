// import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:wtc_wallet_app/app/data/enums/api.dart';
import 'package:wtc_wallet_app/app/data/services/storage/services.dart';
import 'package:wtc_wallet_app/app/data/services/wallet_service.dart';

class TokenDetailController extends GetxController {
  final transactions = [].obs;
  final txList = [].obs;
  final filtered = [].obs;
  final token = Get.arguments['token'];
  final balance = Get.arguments['balance'];

  final hs = Get.find<HiveService>();
  final ws = Get.find<WalletService>();

  @override
  void onInit() {
    super.onInit();
    // showTotal();
    getTxList();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {}

  showTotal() {
    // final r = hs
    //     .getTransactions()
    //     .where((tx) =>
    //         tx?.token == token &&
    //         (tx?.from == ws.current.value?.address ||
    //             tx?.to == ws.current.value?.address))
    //     .toList();
    // r.sort((a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
    // transactions.value = r;
    filtered.value = txList;
  }

  showIn() {
    // final r = hs
    //     .getTransactions()
    //     .where(
    //         (tx) => tx?.token == token && (tx?.to == ws.current.value?.address))
    //     .toList();
    // r.sort((a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
    // transactions.value = r;
    filtered.value = txList
        .where((tx) => tx['transaction_to'] == ws.current.value?.address)
        .toList();
  }

  showOut() {
    // final r = hs
    //     .getTransactions()
    //     .where((tx) =>
    //         tx?.token == token && (tx?.from == ws.current.value?.address))
    //     .toList();
    // r.sort((a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
    // transactions.value = r;
    filtered.value = txList
        .where((tx) => tx['transaction_from'] == ws.current.value?.address)
        .toList();
  }

  getTxList() async {
    String path = '';
    if (token == 'wtc') {
      path = wtcTxListPath;
    } else if (token == 'wta') {
      path = wtaTxListPath;
    }

    final url = Uri.https(txListHost, path, {
      'page_index': '1',
      'page_size': '100',
      'address': ws.current.value?.address
    });
    // debugPrint('url:($url)');
    try {
      final res = await get(url);
      final data = jsonDecode(res.body);
      txList.value = data['data']['list'];
      // debugPrint('txList.value:($txList)');
      filtered.value = txList;
    } catch (e) {
      EasyLoading.showError('net error, please retry.');
    }
  }
}
