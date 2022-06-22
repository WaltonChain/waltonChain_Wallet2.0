import 'package:get/get.dart';

import '../controllers/otc_controller.dart';

class OtcBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtcController>(
      () => OtcController(),
    );
  }
}
