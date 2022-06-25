import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
import 'package:wtc_wallet_app/app/data/models/wallet.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

class WalletCard extends StatelessWidget {
  WalletCard({
    Key? key,
    required this.onTap,
    required this.wallet,
  }) : super(key: key);

  final Function()? onTap;
  final Wallet wallet;

  final wc = Get.find<WalletService>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () async {
        await Clipboard.setData(ClipboardData(text: wallet.address));
        Get.snackbar('Address copied', 'Address copied to clipboard',
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM);
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(105, 0, 217, 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallet.name,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  children: [
                    Text(
                      Utils.ellipsisedHash(wallet.address ??
                          '0x0000000000000000000000000000000000000000'),
                      style: const TextStyle(
                          fontSize: 12.0,
                          color: Color.fromRGBO(255, 255, 255, 0.65)),
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    // const Icon(
                    //   Icons.copy,
                    //   size: 12.0,
                    // ),
                  ],
                ),
              ],
            ),
            wallet.address == wc.current.value?.address
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
