import 'package:get/get.dart';

import '../controllers/place_record_controller.dart';

class PlaceRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaceRecordController>(
      () => PlaceRecordController(),
    );
  }
}
