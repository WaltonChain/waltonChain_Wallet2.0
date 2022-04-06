import 'package:get/get.dart';

import '../controllers/transaction_record_controller.dart';

class TransactionRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionRecordController>(
      () => TransactionRecordController(),
    );
  }
}
