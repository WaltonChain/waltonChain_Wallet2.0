import 'package:get/get.dart';

import '../controllers/receive_controller.dart';

class ReceiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiveController>(
      () => ReceiveController(),
    );
  }
}
