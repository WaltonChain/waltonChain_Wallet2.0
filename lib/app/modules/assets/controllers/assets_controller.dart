import 'package:get/get.dart';
// import 'package:wtc_wallet_app/app/data/enums/blockchain.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/data/services/blockchain_service.dart';
import 'package:wtc_wallet_app/app/data/services/wallet_service.dart';
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
  final bs = Get.find<BlockchainService>();

  @override
  void onInit() async {
    super.onInit();
    ever(wc.current, (wallet) async {
      await getBalances(wallet);
    });
    getBalances(wc.current.value);
    // test
    // final ids = await bs.getOrderIds(wc.current.value!);
    // await bs.getOrderDetail(0);
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
      EasyLoading.show(status: 'Loading...');
      var values = await Future.wait([
        bs.getWtcBalance(wc.current.value?.address),
        bs.getWtaBalance(wc.current.value?.address),
        bs.getWtcPrice(),
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
