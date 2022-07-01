import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TransactionDetailController extends GetxController {
  final amount = Get.arguments['amount'];
  final from = Get.arguments['from'];
  final to = Get.arguments['to'];
  final hash = Get.arguments['hash'];
  final time = Get.arguments['time'];
  final token = Get.arguments['token'];
  final status = Get.arguments['status'];

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

  copyFrom() async {
    await Clipboard.setData(ClipboardData(text: from));
    Get.snackbar('Success', 'Copied');
  }

  copyTo() async {
    await Clipboard.setData(ClipboardData(text: to));
    Get.snackbar('Success', 'Copied');
  }

  copyHash() async {
    await Clipboard.setData(ClipboardData(text: hash));
    Get.snackbar('Success', 'Copied');
  }
}
