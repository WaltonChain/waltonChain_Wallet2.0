import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';
import 'package:ota_update/ota_update.dart';

class SplashController extends GetxController {
  final wc = Get.find<WalletService>();

  @override
  void onInit() async {
    super.onInit();
    await tryOtaUpdate();
  }

  @override
  void onReady() {
    super.onReady();

    if (wc.wallets.isEmpty) {
      Get.offNamed(Routes.CREATE_WALLET);
    } else {
      Get.offNamed(Routes.HOME);
    }
  }

  @override
  void onClose() {}

  Future<void> tryOtaUpdate() async {
    try {
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate()
          .execute(
        'http://monitor.kirinpool.cn/wtc_wallet_app.apk',
        destinationFilename: 'wtc_wallet_app.apk',
        //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
        sha256checksum:
            'ac03e532a02db9cc52b7112adabd9948fba20ca25448a3ac70da8f8cc598981f',
      )
          .listen(
        (OtaEvent event) {
          // setState(() => currentEvent = event);
          // debugPrint('tryOtaUpdate event:($event)');
        },
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      // debugPrint('Failed to make OTA update. Details: $e');
    }
  }
}
