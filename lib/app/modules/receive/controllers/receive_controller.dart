import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

class ReceiveController extends GetxController {
  final count = 0.obs;
  final ws = Get.find<WalletService>();
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
  void increment() => count.value++;

  void clickCopy() {
    Utils.copyAndShow(ws.current.value?.address ?? '');
  }
}
