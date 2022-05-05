import 'package:get/get.dart';

import '../controllers/staking_controller.dart';

class StakingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StakingController>(
      () => StakingController(),
    );
  }
}
