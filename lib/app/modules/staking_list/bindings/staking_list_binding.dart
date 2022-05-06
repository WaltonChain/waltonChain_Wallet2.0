import 'package:get/get.dart';

import '../controllers/staking_list_controller.dart';

class StakingListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StakingListController>(
      () => StakingListController(),
    );
  }
}
