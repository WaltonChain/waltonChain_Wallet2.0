import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/services/blockchain_service.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

class PlaceRecordController extends GetxController {
  final WalletService ws = Get.find();
  final BlockchainService bs = Get.find();

  dynamic ids = [].obs;
  dynamic records = [].obs;

  @override
  void onInit() async {
    super.onInit();
    final list = await bs.orderList(wallet: ws.current.value!);
    ids.value = list[0];
    records.value = list[1];
    // print('PlaceRecordController onInit records:($records)');
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

}
