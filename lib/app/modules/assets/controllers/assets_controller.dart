import 'package:get/get.dart';
// import 'package:wtc_wallet_app/app/data/constants/blockchain.dart';
import 'package:wtc_wallet_app/app/data/models/blockchain.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AssetsController extends GetxController {
  // var isLoading = false.obs;
  var wtcBalance = 0.0.obs;
  var wtaBalance = 0.0.obs;
  var wtcPrice = 0.0.obs;
  var wtcAmount = 0.0.obs;
  // var wtaPrice = 0.0.obs;
  var wtaAmount = 0.0.obs;

  final wc = Get.find<WalletService>();

  @override
  void onInit() {
    super.onInit();
    ever(wc.current, (wallet) async {
      await getBalances(wallet);
    });
    getBalances(wc.current.value);
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {}

  Future<void> onRefresh() async {
    await getBalances(wc.current.value);
  }

  getBalances(wallet) async {
    if (wallet != null) {
      final address = wallet.address;

      EasyLoading.show(status: 'Loading...');
      var values = await Future.wait([
        Blockchain.getWtcBalance(address),
        Blockchain.getWtaBalance(address),
        Blockchain.getWtcPrice(),
      ]);
      EasyLoading.showSuccess('Loading Success');

      wtcBalance.value = values[0];
      wtaBalance.value = values[1];
      wtcPrice.value = values[2];
      // wtaPrice.value = wtcPrice.value / 10;
      wtcAmount.value = wtcBalance.value * wtcPrice.value;
      wtaAmount.value = wtaBalance.value * wtcPrice.value / 10;
    }
  }

  clickScan() {
    if (wc.current.value == null) {
      Get.snackbar('No Wallet', 'Please Create or Import a Wallet');
    } else {
      Get.toNamed(Routes.CAMERA_SCAN, arguments: wc.current.value);
    }
  }

  clickAsset() {
    if (wc.current.value == null) {
      Get.snackbar('No Wallet', 'Please Create or Import a Wallet');
    } else {
      Get.toNamed(Routes.WALLET_DETAIL, arguments: wc.current.value);
    }
  }

  clickSend() {
    if (wc.current.value == null) {
      Get.snackbar('No Wallet', 'Please Create or Import a Wallet');
    } else {
      Get.toNamed(Routes.SEND);
    }
  }

  clickReceive() {
    if (wc.current.value == null) {
      Get.snackbar('No Wallet', 'Please Create or Import a Wallet');
    } else {
      Get.toNamed(Routes.RECEIVE, arguments: wc.current.value);
    }
  }

  clickWtc() {
    if (wc.current.value == null) {
      Get.snackbar('No Wallet', 'Please Create or Import a Wallet');
    } else {
      Get.toNamed(Routes.TOKEN_DETAIL,
          arguments: {'token': 'wtc', 'balance': wtcBalance.value});
    }
  }

  clickWta() {
    if (wc.current.value == null) {
      Get.snackbar('No Wallet', 'Please Create or Import a Wallet');
    } else {
      Get.toNamed(Routes.TOKEN_DETAIL,
          arguments: {'token': 'wta', 'balance': wtaBalance.value});
    }
  }
}
