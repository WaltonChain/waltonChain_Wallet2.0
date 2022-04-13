import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';
import 'package:ota_update/ota_update.dart';
import 'package:http/http.dart' as http;

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
    // toOtherPage();
  }

  @override
  void onClose() {}

  Future<void> tryOtaUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    const url = 'https://wtaapp.waltonchain.org/latest';
    final res = await http.get(Uri.parse(url));
    // print('res.body: ${res.body}');
    final latest = jsonDecode(res.body);
    final needUpdate =
        Utils.compareVersion(packageInfo.version, latest['version']);
    print('needUpdate: $needUpdate');

    if (needUpdate) {
      Get.defaultDialog(
          title: 'Found New Version',
          content: const Text('Please update to the latest version'),
          onCancel: () {
            toOtherPage();
          },
          onConfirm: () {
            try {
              //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
              OtaUpdate()
                  .execute(
                latest['downloadUrl'],
                destinationFilename: latest['fileName'],
                //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
                sha256checksum: latest['sha256'],
              )
                  .listen(
                (OtaEvent event) {
                  // setState(() => currentEvent = event);
                  // print('event.status:(${event.status}) event.value:(${event.value})');
                  if (event.status == OtaStatus.DOWNLOADING) {
                    EasyLoading.showProgress(
                        double.parse(event.value ?? '0') / 100,
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
          });
    } else {
      toOtherPage();
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
