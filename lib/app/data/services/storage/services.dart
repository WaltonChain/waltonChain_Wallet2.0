// import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wtc_wallet_app/app/core/utils/keys.dart';
import 'package:wtc_wallet_app/app/data/models/transaction.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
import 'package:wtc_wallet_app/app/data/models/wallet.dart';

class HiveService extends GetxService {
  late Box _box;

  Future<HiveService> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WalletAdapter());
    Hive.registerAdapter(TransactionAdapter());
    _box = await Hive.openBox(hiveBoxKey);
    return this;
  }

  T read<T>(String key) {
    return _box.get(key);
  }

  void write(String key, dynamic value) async {
    await _box.put(key, value);
  }

  getWallets() async {
    final ws = await _box.get('wallets') ?? [];
    return ws;
  }

  saveWallets(List<dynamic> ws) async {
    // final ws = await getWallets();
    // print('saveWallet 1 ws: $ws');
    // await ws.add(wallet);
    // print('saveWallet 2 ws: $ws');

    // await _box.put('wallets', ws.toList());
    await _box.put('wallets', ws);
    // print('saveWallet 3 ws: ($ws) ws.toList(): ${ws.toList()}');
  }

  void delWallet(Wallet wallet) async {
    final wallets = await getWallets();
    wallets.remove(wallet);
    _box.put('wallets', wallets.toList());
  }

  int getSelectedIndex() {
    final index = _box.get('selectedIndex') ?? -1;
    return index;
  }

  saveSelectedIndex(int index) async {
    await _box.put('selectedIndex', index);
  }

  getTransactions() {
    final txs = _box.get('transactions') ?? [];
    return txs;
  }

  void saveTransaction(Transaction transaction) {
    final ts = _box.get('transactions') ?? [];
    ts.add(transaction);
    _box.put('transactions', ts.toList());
  }

  getPrivateKey(String address) {
    final wallets = _box.get('wallets');
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
