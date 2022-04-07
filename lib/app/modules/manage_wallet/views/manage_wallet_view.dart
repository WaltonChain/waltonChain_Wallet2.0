import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/component/back_bar.dart';
import 'package:wtc_wallet_app/app/component/wallet_card.dart';
import 'package:wtc_wallet_app/app/component/wtc_icon.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

import '../controllers/manage_wallet_controller.dart';

class ManageWalletView extends GetView<ManageWalletController> {
  ManageWalletView({Key? key}) : super(key: key);

  final wc = Get.find<WalletService>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [BackBar(title: 'Manage your wallets')],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: const Color.fromRGBO(248, 250, 251, 1),
                    child: ListView(
                      children: [
                        const SizedBox(height: 12.0),
                        WtcIcon(onPressed: () {}),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Waltonchain'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                Get.bottomSheet(
                                  Container(
                                    color: Colors.white,
                                    height: 100.0,
                                    child: Column(
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              Get.toNamed(Routes.CREATE_WALLET),
                                          child: const Text('Create Wallet'),
                                        ),
                                        TextButton(
                                            onPressed: () => Get.toNamed(
                                                Routes.IMPORT_WALLET),
                                            child: const Text('Import Wallet')),
                                      ],
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0.0,
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Expanded(
                          child: Obx(() => ListView.builder(
                              itemCount: wc.wallets.length,
                              itemBuilder: (context, index) {
                                return WalletCard(
                                  onTap: () {
                                    Get.toNamed(Routes.WALLET_DETAIL,
                                        arguments: wc.wallets[index]);
                                  },
                                  wallet: wc.wallets[index],
                                );
                              })),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
