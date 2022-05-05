import 'package:get/get.dart';

import '../controllers/swap_controller.dart';
import '../controllers/stake_controller.dart';

class DappWtcBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SwapController>(
      () => SwapController(),
    );
    Get.lazyPut<StakeController>(
      () => StakeController(),
    );
  }
}
