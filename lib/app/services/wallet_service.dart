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

    // ever(wallets, (callback) {
    //   debugPrint('$wallets');
    // });
    print('selectedIndex: ${selectedIndex.value}');
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
    print(
        'before add wallet, wallets:($wallets) wallets.length:${wallets.length}');
    wallets.add(wallet);
    print('after add wallet, wallets:($wallets)');
    print('after add wallet 1 wallets.length:${wallets.length}');
    await hs.saveWallet(wallet);
    print('after add wallet 2 wallets.length:${wallets.length}');

    final index = wallets.length - 1;
    print('after add wallet 3 wallets.length:${wallets.length}');
    await setIndex(index);
    print('after add wallet 4 wallets.length:${wallets.length}');
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
