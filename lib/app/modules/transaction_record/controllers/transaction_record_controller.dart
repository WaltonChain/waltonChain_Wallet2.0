import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/services/blockchain_service.dart';
import 'package:wtc_wallet_app/app/data/services/storage/services.dart';

class TransactionRecordController extends GetxController {
  final records = [].obs;

  final hs = Get.find<HiveService>();
  final bs = Get.find<BlockchainService>();

  @override
  void onInit() async {
    super.onInit();
    // final txs = hs.getTransactions();
    // final requests = txs.map((tx) => bs.getReceipt(tx.hash)).toList();
    // final valids = await Future.wait((requests));
    // valids.asMap().forEach((key, value) {
    //   if (value) {
    //     records.add(txs[key]);
    //   }
    // });
    records.value = hs.getTransactions();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {}
}
