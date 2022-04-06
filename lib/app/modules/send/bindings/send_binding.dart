import 'package:get/get.dart';

import '../controllers/send_controller.dart';

class SendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendController>(
      () => SendController(),
    );
  }
}
