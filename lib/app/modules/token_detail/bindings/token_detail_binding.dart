import 'package:get/get.dart';

import '../controllers/token_detail_controller.dart';

class TokenDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TokenDetailController>(
      () => TokenDetailController(),
    );
  }
}
