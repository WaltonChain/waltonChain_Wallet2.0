import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';

import '../controllers/me_controller.dart';

class NaviRow extends StatelessWidget {
  const NaviRow({
    Key? key,
    required this.onTap,
    required this.leading,
    required this.title,
  }) : super(key: key);

  final void Function()? onTap;
  final String leading;
  final String title;

  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   leading: Icon(leading, size: 24.0),
    //   title: Text(title, style: const TextStyle(fontSize: 16.0)),
    //   trailing: const Icon(Icons.chevron_right, size: 24.0),
    // );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        margin: const EdgeInsets.only(bottom: 2.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  leading,
                  width: 24.0,
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Text(title),
              ],
            ),
            const Icon(Icons.chevron_right, size: 24.0)
          ],
        ),
      ),
    );
  }
}

class MeView extends GetView<MeController> {
  const MeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          alignment: Alignment.topLeft,
          child: const Text('My Profile', style: TextStyle(fontSize: 20.0)),
        ),
        Expanded(
            child: ListView(
          children: [
            NaviRow(
              onTap: () => Get.toNamed(Routes.ASSETS_OVERVIEW),
              leading: 'assets/images/assets.png',
              title: 'Assets Overview',
            ),
            NaviRow(
              onTap: () => Get.toNamed(Routes.MANAGE_WALLET),
              leading: 'assets/images/wallet.png',
              title: 'Manage your wallet',
            ),
            const SizedBox(
              height: 32.0,
            ),
            NaviRow(
              onTap: () => Get.toNamed(Routes.TRANSACTION_RECORD),
              leading: 'assets/images/record.png',
              title: 'Transaction Record',
            ),
            // const SizedBox(height: 16.0),
            // NaviRow(
            //   onTap: () => Get.toNamed('/address_book'),
            //   leading: 'assets/images/book.png',
            //   title: 'Address Book',
            // ),
            // const SizedBox(height: 16.0),
            // NaviRow(
            //   onTap: () => Get.toNamed('/setting'),
            //   leading: 'assets/images/setting.png',
            //   title: 'Settings',
            // ),
            // NaviRow(
            //   onTap: () => Get.toNamed('/manage_coin'),
            //   leading: 'assets/images/coins.png',
            //   title: 'Manage your coins',
            // ),
            // const SizedBox(height: 16.0),
            // NaviRow(
            //   onTap: () => Get.toNamed('/support'),
            //   leading: 'assets/images/support.png',
            //   title: 'Support and Feedback',
            // ),
            // NaviRow(
            //   onTap: () => Get.toNamed('/about'),
            //   leading: 'assets/images/about.png',
            //   title: 'About Us',
            // ),
          ],
        )),
      ],
    );
  }
}
