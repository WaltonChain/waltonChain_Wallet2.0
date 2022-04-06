import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/services/hive_service.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DenpendencyInjection {
  static Future<void> init() async {
    await dotenv.load(fileName: ".env");

    await Get.putAsync(() => HiveService().init());
    // Get.put(HiveService());
    Get.put(WalletService());

    await setInAppWebview();

    // EasyLoading.instance
    // ..displayDuration = const Duration(milliseconds: 2000)
    // ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    // ..loadingStyle = EasyLoadingStyle.dark;
    // ..indicatorSize = 45.0
    // ..radius = 10.0
    // ..progressColor = Colors.yellow
    // ..backgroundColor = Colors.green
    // ..indicatorColor = Colors.yellow
    // ..textColor = Colors.yellow
    // ..maskColor = Colors.blue.withOpacity(0.5)
    // ..userInteractions = true
    // ..dismissOnTap = false
    // ..customAnimation = CustomAnimation();
  }

  static setInAppWebview() async {
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

      var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
          AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
          AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController =
            AndroidServiceWorkerController.instance();

        serviceWorkerController.serviceWorkerClient =
            AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            // print(request);
            return null;
          },
        );
      }
    }
  }
}
