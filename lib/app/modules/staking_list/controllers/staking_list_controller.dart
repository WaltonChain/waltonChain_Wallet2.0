import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/services/blockchain_service.dart';
import 'package:wtc_wallet_app/app/data/services/wallet_service.dart';

class StakingListController extends GetxController {
  final orders = [].obs;

  final wc = Get.find<WalletService>();
  final bs = Get.find<BlockchainService>();

  @override
  void onInit() {
    super.onInit();
    getOrderData();
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {}

  void getOrderData() async {
    EasyLoading.show(status: 'Loading...');
    final ids = await bs.getOrderIds(wc.current.value!);
    final res = await Future.wait(ids.map((id) => bs.getOrderDetail(id)));
    orders.value = res;
    // print('getOrderData orders:($orders)');
    EasyLoading.showSuccess('Loading Success');
    update();
  }
}
