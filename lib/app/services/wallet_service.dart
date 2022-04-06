import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/models/wallet.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/services/hive_service.dart';

class WalletService extends GetxService {
  final wallets = [].obs;
  final selectedIndex = (-1).obs;
  late final Rx<Wallet?> current = Rx<Wallet?>(null);

  final hs = Get.find<HiveService>();

  @override
  onInit() {
    super.onInit();
    debugPrint('WalletService init');
    selectedIndex.value = hs.getSelectedIndex();

    if (selectedIndex.value != -1) {
      wallets.value = hs.getWallets();
      current.value = wallets[selectedIndex.value];
    }

    ever(selectedIndex, (callback) {
      if (selectedIndex.value == -1) {
        current.value = null;
      } else if (wallets.isNotEmpty) {
        current.value = wallets.elementAt(selectedIndex.value);
      }
    });
  }

  setIndex(int index) {
    selectedIndex.value = index;
    hs.saveSelectedIndex(index);
  }

  add(Wallet wallet) {
    wallets.add(wallet);
    hs.saveWallet(wallet);

    final index = wallets.length - 1;
    setIndex(index);
  }

  del(Wallet wallet) {
    final index = wallets.indexOf(wallet);

    wallets.remove(wallet);
    hs.delWallet(wallet);

    if (wallets.isEmpty) {
      setIndex(-1);
      Get.offNamed(Routes.CREATE_WALLET);
    } else {
      if (index == selectedIndex.value) {
        setIndex(0);
      } else if (index < selectedIndex.value) {
        setIndex(selectedIndex.value - 1);
      }
      Get.offNamed(Routes.MANAGE_WALLET);
    }
  }
}
