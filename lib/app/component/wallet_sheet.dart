import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/component/wallet_card.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

class WalletSheet extends StatelessWidget {
  WalletSheet({Key? key}) : super(key: key);

  final wc = Get.find<WalletService>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Image.asset(
                  'assets/images/close.png',
                  width: 18.0,
                ),
              ),
              const Text(
                'Select Wallet',
                style: TextStyle(fontSize: 18.0),
              ),
              TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.MANAGE_WALLET);
                  },
                  child: const Text(
                    'Manage',
                    style: TextStyle(
                      color: Color.fromRGBO(130, 0, 255, 1),
                    ),
                  )),
            ],
          ),
        ),
        const Divider(
          height: 1.0,
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/images/wtc.png',
                          width: 36.0,
                        ),
                      );
                    }),
              ),
              const VerticalDivider(),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Waltonchain'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: wc.wallets.length,
                        itemBuilder: (context, index) {
                          return WalletCard(
                            onTap: () {
                              wc.setIndex(index);
                              Get.back();
                            },
                            wallet: wc.wallets[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
