import 'package:get/get.dart';

import '../modules/assets/bindings/assets_binding.dart';
import '../modules/assets/views/assets_view.dart';
import '../modules/assets_overview/bindings/assets_overview_binding.dart';
import '../modules/assets_overview/views/assets_overview_view.dart';
import '../modules/camera_scan/bindings/camera_scan_binding.dart';
import '../modules/camera_scan/views/camera_scan_view.dart';
import '../modules/create_wallet/bindings/create_wallet_binding.dart';
import '../modules/create_wallet/views/create_wallet_view.dart';
import '../modules/dapp/bindings/dapp_binding.dart';
import '../modules/dapp/views/dapp_view.dart';
import '../modules/dapp_wtc/bindings/dapp_wtc_binding.dart';
import '../modules/dapp_wtc/views/dapp_wtc_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/import_wallet/bindings/import_wallet_binding.dart';
import '../modules/import_wallet/views/import_wallet_view.dart';
import '../modules/manage_wallet/bindings/manage_wallet_binding.dart';
import '../modules/manage_wallet/views/manage_wallet_view.dart';
import '../modules/me/bindings/me_binding.dart';
import '../modules/me/views/me_view.dart';
import '../modules/receive/bindings/receive_binding.dart';
import '../modules/receive/views/receive_view.dart';
import '../modules/send/bindings/send_binding.dart';
import '../modules/send/views/send_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/staking/bindings/staking_binding.dart';
import '../modules/staking/views/staking_view.dart';
import '../modules/staking_list/bindings/staking_list_binding.dart';
import '../modules/staking_list/views/staking_list_view.dart';
import '../modules/token_detail/bindings/token_detail_binding.dart';
import '../modules/token_detail/views/token_detail_view.dart';
import '../modules/transaction_detail/bindings/transaction_detail_binding.dart';
import '../modules/transaction_detail/views/transaction_detail_view.dart';
import '../modules/transaction_record/bindings/transaction_record_binding.dart';
import '../modules/transaction_record/views/transaction_record_view.dart';
import '../modules/wallet_detail/bindings/wallet_detail_binding.dart';
import '../modules/wallet_detail/views/wallet_detail_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // static const INITIAL = Routes.HOME;
  // static const INITIAL = Routes.CREATE_WALLET;
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_WALLET,
      page: () => const CreateWalletView(),
      binding: CreateWalletBinding(),
    ),
    GetPage(
      name: _Paths.ASSETS,
      page: () => const AssetsView(),
      binding: AssetsBinding(),
    ),
    GetPage(
      name: _Paths.DAPP,
      page: () => const DappView(),
      binding: DappBinding(),
    ),
    GetPage(
      name: _Paths.ME,
      page: () => const MeView(),
      binding: MeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.MANAGE_WALLET,
      page: () => ManageWalletView(),
      binding: ManageWalletBinding(),
    ),
    GetPage(
      name: _Paths.WALLET_DETAIL,
      page: () => WalletDetailView(),
      binding: WalletDetailBinding(),
    ),
    GetPage(
      name: _Paths.IMPORT_WALLET,
      page: () => const ImportWalletView(),
      binding: ImportWalletBinding(),
    ),
    GetPage(
      name: _Paths.SEND,
      page: () => const SendView(),
      binding: SendBinding(),
    ),
    GetPage(
      name: _Paths.RECEIVE,
      page: () => ReceiveView(),
      binding: ReceiveBinding(),
    ),
    GetPage(
      name: _Paths.TOKEN_DETAIL,
      page: () => TokenDetailView(),
      binding: TokenDetailBinding(),
    ),
    GetPage(
      name: _Paths.DAPP_WTC,
      page: () => const DappWtcView(),
      binding: DappWtcBinding(),
    ),
    GetPage(
      name: _Paths.ASSETS_OVERVIEW,
      page: () => const AssetsOverviewView(),
      binding: AssetsOverviewBinding(),
    ),
    GetPage(
      name: _Paths.TRANSACTION_RECORD,
      page: () => const TransactionRecordView(),
      binding: TransactionRecordBinding(),
    ),
    GetPage(
      name: _Paths.CAMERA_SCAN,
      page: () => const CameraScanView(),
      binding: CameraScanBinding(),
    ),
    GetPage(
      name: _Paths.TRANSACTION_DETAIL,
      page: () => const TransactionDetailView(),
      binding: TransactionDetailBinding(),
    ),
    GetPage(
      name: _Paths.STAKING,
      page: () => const StakingView(),
      binding: StakingBinding(),
    ),
    GetPage(
      name: _Paths.STAKING_LIST,
      page: () => const StakingListView(),
      binding: StakingListBinding(),
    ),
  ];
}
