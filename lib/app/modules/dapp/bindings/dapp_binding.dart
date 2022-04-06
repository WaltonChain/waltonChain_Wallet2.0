import 'package:get/get.dart';

import '../controllers/dapp_controller.dart';

class DappBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DappController>(
      () => DappController(),
    );
  }
}
