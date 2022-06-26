import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/services/storage/services.dart';

class TransactionRecordController extends GetxController {
  final records = [].obs;

  final hs = Get.find<HiveService>();

  @override
  void onInit() {
    super.onInit();
    records.value = hs.getTransactions();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {}
}
