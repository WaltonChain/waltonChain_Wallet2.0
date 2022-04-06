import 'package:get/get.dart';

import '../controllers/manage_wallet_controller.dart';

class ManageWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageWalletController>(
      () => ManageWalletController(),
    );
  }
}
