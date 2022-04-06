import 'package:get/get.dart';

import '../controllers/assets_overview_controller.dart';

class AssetsOverviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssetsOverviewController>(
      () => AssetsOverviewController(),
    );
  }
}
