import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wtc_wallet_app/app/data/models/transaction.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
import 'package:wtc_wallet_app/app/data/models/wallet.dart';

class HiveService extends GetxService {
  Box? box;

  Future<HiveService> init() async {
    debugPrint('HiveService init');
    await Hive.initFlutter();

    Hive.registerAdapter(WalletAdapter());
    Hive.registerAdapter(TransactionAdapter());

    box = await Hive.openBox('db');
    return this;
  }

  getWallets() {
    final wallets = box?.get('wallets') ?? [];
    return wallets;
  }

  void saveWallet(Wallet wallet) {
    final wallets = getWallets();
    wallets.add(wallet);
    box?.put('wallets', wallets.toList());
  }

  void delWallet(Wallet wallet) {
    final wallets = getWallets();
    wallets.remove(wallet);
    box?.put('wallets', wallets.toList());
  }

  int getSelectedIndex() {
    final index = box?.get('selectedIndex') ?? -1;
    return index;
  }

  void saveSelectedIndex(int index) {
    box?.put('selectedIndex', index);
  }

  getTransactions() {
    final txs = box?.get('transactions') ?? [];
    return txs;
  }

  void saveTransaction(Transaction transaction) {
    final ts = box?.get('transactions') ?? [];
    ts.add(transaction);
    box?.put('transactions', ts.toList());
  }

  getPrivateKey(String address) {
    final wallets = box?.get('wallets');
    final wallet =
        wallets.firstWhere((w) => w.address == address, orElse: () => null);
    if (wallet == null) {
      return '';
    } else {
      final pk = Utils.privateKeyFromKeyStore(wallet.keyStore, wallet.pass);
      return pk;
    }
  }
}
