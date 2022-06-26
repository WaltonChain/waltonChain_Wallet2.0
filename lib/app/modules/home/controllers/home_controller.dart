import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/services/storage/repository.dart';

class HomeController extends GetxController {
  WalletRepository walletRepository;
  HomeController({required this.walletRepository});

  var index = 0.obs;

  // final wallets = <Wallet>[].obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   wallets.assignAll(walletRepository.readWallets());
  //   ever(wallets, (_) => walletRepository.writeWallets(wallets));
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  void setIndex(int i) {
    index.value = i;
  }
}
