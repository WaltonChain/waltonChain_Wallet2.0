import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/models/wallet.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/data/services/storage/services.dart';

class WalletService extends GetxService {
  final wallets = [].obs;
  final selectedIndex = (-1).obs;
  late final Rx<Wallet?> current = Rx<Wallet?>(null);

  final hs = Get.find<HiveService>();

  @override
  onInit() async {
    super.onInit();
    selectedIndex.value = hs.getSelectedIndex();

    if (selectedIndex.value != -1) {
      wallets.value = await hs.getWallets();
      current.value = wallets[selectedIndex.value];
    }

    ever(selectedIndex, (callback) {
      if (selectedIndex.value == -1) {
        current.value = null;
      } else if (wallets.isNotEmpty) {
        current.value = wallets.elementAt(selectedIndex.value);
      }
    });

    ever(wallets, (callback) {
      // ignore: invalid_use_of_protected_member
      hs.saveWallets(wallets.value);
    });
    ever(selectedIndex, (callback) {
      debugPrint('$selectedIndex');
    });
  }

  setIndex(int index) async {
    selectedIndex.value = index;
    await hs.saveSelectedIndex(index);
  }

  add(Wallet wallet) async {
    debugPrint('wallet service add func start');
    wallets.add(wallet);
    // await hs.saveWallet(wallet);

    final index = wallets.length - 1;
    await setIndex(index);
  }

  del(Wallet wallet) {
    final index = wallets.indexOf(wallet);

    wallets.remove(wallet);
    hs.delWallet(wallet);

    if (wallets.isEmpty) {
      setIndex(-1);
      Get.offAllNamed(Routes.CREATE_WALLET);
    } else {
      if (index == selectedIndex.value) {
        setIndex(0);
      } else if (index < selectedIndex.value) {
        setIndex(selectedIndex.value - 1);
      }
      Get.offAllNamed(Routes.MANAGE_WALLET);
    }
  }
}
