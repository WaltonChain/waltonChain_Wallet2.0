import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/modules/assets/controllers/assets_controller.dart';

class IconScan extends GetView<AssetsController> {
  const IconScan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        controller.clickScan();
      },
      icon: const Icon(Icons.qr_code_scanner),
      constraints: const BoxConstraints(),
      padding: EdgeInsets.zero,
    );
  }
}
