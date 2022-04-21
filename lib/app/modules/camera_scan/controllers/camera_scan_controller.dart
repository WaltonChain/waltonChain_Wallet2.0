import 'package:get/get.dart';
import 'package:scan/scan.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';

class CameraScanController extends GetxController {
  // final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  ScanController? sc = ScanController();
  String qrcode = '';

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {
    // controller?.dispose();
    super.dispose();
  }

  onCapture(String qrcode) {
    this.qrcode = qrcode;
    print('onCapture: $qrcode');
    if (qrcode.startsWith('0x') && qrcode.length == 42) {
      Get.offNamed(Routes.SEND, arguments: {'to': qrcode});
    } else {
      Get.offNamed(Routes.HOME);
      Get.snackbar(
        'Error', 'Invalid QR Code',
        // snackPosition: SnackPosition.BOTTOM,
        // backgroundColor: Colors.red,
        // borderRadius: BorderRadius.circular(10.0),
        // margin: EdgeInsets.all(10),
        // snackStyle: SnackStyle.FLOATING,
        // duration: Duration(seconds: 2)
      );
    }
  }
}
