import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/modules/assets/controllers/assets_controller.dart';

class AssetsOverviewController extends GetxController {
  final visible = false.obs;
  final totalBalance = 0.0.obs;

  final ac = Get.find<AssetsController>();
  @override
  void onInit() {
    super.onInit();
    totalBalance.value = ac.wtcBalance.value;
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {}

  toggleVisible() {
    visible.value = !visible.value;
  }
}
