import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/providers/wallet/provider.dart';
import 'package:wtc_wallet_app/app/data/services/storage/repository.dart';
import 'package:wtc_wallet_app/app/modules/assets/controllers/assets_controller.dart';
import 'package:wtc_wallet_app/app/modules/dapp/controllers/dapp_controller.dart';
import 'package:wtc_wallet_app/app/modules/me/controllers/me_controller.dart';
import 'package:wtc_wallet_app/app/modules/otc/controllers/otc_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
          walletRepository: WalletRepository(walletProvider: WalletProvider())),
    );
    Get.lazyPut<AssetsController>(
      () => AssetsController(),
    );
    Get.lazyPut<DappController>(
      () => DappController(),
    );
    Get.lazyPut<OtcController>(
      () => OtcController(),
    );
    Get.lazyPut<MeController>(
      () => MeController(),
    );
  }
}
