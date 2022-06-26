import 'package:wtc_wallet_app/app/data/models/wallet.dart';
import 'package:wtc_wallet_app/app/data/providers/wallet/provider.dart';

class WalletRepository {
  WalletProvider walletProvider;
  WalletRepository({required this.walletProvider});

  List<Wallet> readWallets() => walletProvider.readWallets();
  void writeWallets(List<Wallet> wallets) =>
      walletProvider.writeWallets(wallets);
}
