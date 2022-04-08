import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';
import 'package:ota_update/ota_update.dart';

class SplashController extends GetxController {
  final wc = Get.find<WalletService>();

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() async {
    super.onReady();
    await tryOtaUpdate();
    toOtherPage();
  }

  @override
  void onClose() {}

  Future<void> tryOtaUpdate() async {
    try {
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate()
          .execute(
        'http://monitor.kirinpool.cn/wtc_wallet.apk',
        destinationFilename: 'wtc_wallet.apk',
        //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
        // sha256checksum:
        //     '5ec538944310049a9e0794ed856beccbff105cb17c299c8a42f2419ebf10238a',
      )
          .listen(
        (OtaEvent event) {
          // setState(() => currentEvent = event);
          // print('event.status:(${event.status}) event.value:(${event.value})');
          if (event.status == OtaStatus.DOWNLOADING) {
            EasyLoading.showProgress(double.parse(event.value ?? '0') / 100,
                status: 'App Updating...');
            if (double.parse(event.value ?? '0') == 100) {
              EasyLoading.dismiss();
            }
          }
        },
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      // debugPrint('Failed to make OTA update. Details: $e');
    }
  }

  void toOtherPage() {
    if (wc.wallets.isEmpty) {
      Get.offNamed(Routes.CREATE_WALLET);
    } else {
      Get.offNamed(Routes.HOME);
    }
  }
}
