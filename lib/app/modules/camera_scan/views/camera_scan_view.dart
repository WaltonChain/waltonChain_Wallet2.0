import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan/scan.dart';
import 'package:wtc_wallet_app/app/widgets/back_bar.dart';

import '../controllers/camera_scan_controller.dart';

class CameraScanView extends GetView<CameraScanController> {
  const CameraScanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.9;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: BackBar(title: 'Scan'),
            ),
            const SizedBox(height: 100),
            const Text('Scan the QR code and transfer WTC/WTA to it'),
            const SizedBox(height: 16),
            SizedBox(
              width: width,
              height: width,
              child: ScanView(
                controller: controller.sc,
                // custom scan area, if set to 1.0, will scan full area
                scanAreaScale: 1.0,
                scanLineColor: Colors.green.shade400,
                onCapture: controller.onCapture,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
