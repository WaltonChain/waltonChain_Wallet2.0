import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/data/services/wallet_service.dart';

class DappController extends GetxController {
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

  clickDapp() {
    if (ws.current.value == null) {
      Get.snackbar('No Wallet', 'Please Create or Import a Wallet');
    } else {
      Get.toNamed(Routes.DAPP_WTC);
    }
  }
}
