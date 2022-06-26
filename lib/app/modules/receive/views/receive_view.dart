import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wtc_wallet_app/app/widgets/back_bar.dart';
import 'package:wtc_wallet_app/app/widgets/full_width_button.dart';
import 'package:wtc_wallet_app/app/data/services/wallet_service.dart';

import '../controllers/receive_controller.dart';

class ReceiveView extends GetView<ReceiveController> {
  ReceiveView({Key? key}) : super(key: key);

  final wc = Get.put(WalletService());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: const BackBar(title: 'Receive')),
            Container(
              padding: const EdgeInsets.all(32.0),
              color: Colors.white,
              child: Column(
                children: [
                  const Text('Scan the QR code and transfer WTC/WTA to it'),
                  const SizedBox(height: 32.0),
                  Obx(() => QrImage(
                        data: wc.current.value?.address ?? '',
                        version: QrVersions.auto,
                        size: 200.0,
                      )),
                  const SizedBox(height: 32.0),
                  const Text('Wallet Address'),
                  const SizedBox(height: 8.0),
                  Obx(() => Text(
                        wc.current.value?.address ?? '',
                        textAlign: TextAlign.center,
                      )),
                  const SizedBox(height: 8.0),
                  FullWidthButton(
                    text: 'Copy',
                    onPressed: () {
                      controller.clickCopy();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
