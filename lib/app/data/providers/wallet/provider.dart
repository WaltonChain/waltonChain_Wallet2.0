import 'dart:convert';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/core/utils/keys.dart';
import 'package:wtc_wallet_app/app/data/models/wallet.dart';
import 'package:wtc_wallet_app/app/data/services/storage/services.dart';

class WalletProvider {
  final _storage = Get.find<HiveService>();

  List<Wallet> readWallets() {
    var wallets = <Wallet>[];
    jsonDecode(_storage.read(walletsKey).toString())
        .forEach((i) => wallets.add(Wallet.fromJson(i)));
    return wallets;
  }

  void writeWallets(List<Wallet> wallets) {
    _storage.write(walletsKey, wallets);
  }
}
