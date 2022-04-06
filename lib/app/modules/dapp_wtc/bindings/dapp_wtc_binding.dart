import 'package:get/get.dart';

import 'package:wtc_wallet_app/app/modules/dapp_wtc/controllers/staking_controller.dart';

import '../controllers/swap_controller.dart';

class DappWtcBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SwapController>(
      () => SwapController(),
    );
    Get.lazyPut<StakingController>(
      () => StakingController(),
    );
  }
}
