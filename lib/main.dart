import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wtc_wallet_app/app/services/di.dart';
import 'package:ota_update/ota_update.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DenpendencyInjection.init();
  await tryOtaUpdate();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "WTC Wallet",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      builder: EasyLoading.init(),
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
    );
  }
}

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
        debugPrint('tryOtaUpdate event:($event)');
      },
    );
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    debugPrint('Failed to make OTA update. Details: $e');
  }
}
