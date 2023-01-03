import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/core/values/colors.dart';
import 'package:wtc_wallet_app/app/data/enums/blockchain.dart';
import 'package:wtc_wallet_app/app/data/services/blockchain_service.dart';
import 'package:wtc_wallet_app/app/widgets/account_sheet.dart';
import 'package:wtc_wallet_app/app/widgets/icon_scan.dart';
import 'package:wtc_wallet_app/app/widgets/wallet_sheet.dart';
import 'package:wtc_wallet_app/app/data/services/wallet_service.dart';

import '../controllers/assets_controller.dart';

class AssetsView extends GetView<AssetsController> {
  const AssetsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 13.0,
              ),
              children: [
                SwitchChain(),
                AssetCard(),
                const Buttons(),
                Tokens(),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class TopBar extends GetView<AssetsController> {
  TopBar({Key? key}) : super(key: key);

  final ws = Get.find<WalletService>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon(Icons.wallet_giftcard),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                // builder: (context) => const WalletSheet(),
                builder: (context) {
                  if (ws.wallets.isEmpty) {
                    return const AccountSheet();
                  } else {
                    return WalletSheet();
                  }
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
              );
            },
            icon: Image.asset(
              'assets/images/wallet_list.png',
              width: 20.0,
            ),
          ),
          const Text(
            'Waltonchain Wallet',
            style: TextStyle(fontSize: 20.0),
          ),
          const IconScan(),
        ],
      ),
    );
  }
}

class SwitchChain extends GetView<AssetsController> {
  SwitchChain({Key? key}) : super(key: key);

  final BlockchainService bs = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => Text(
            'Current Chain: ${controller.bs.url.value == baseUrls['WTC'] ? 'WTC' : 'WTA'}')),
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Row(
              children: const [
                Icon(
                  Icons.list,
                  size: 16,
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    'Select Chain',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      // color: Colors.yellow,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: baseUrls.keys
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            // value: bs.url.value,
            onChanged: (value) {
              debugPrint('value:$value');
              // setState(() {
              //   selectedValue = value as String;
              // });
              bs.switchUrl(baseUrls[value].toString());
            },
            icon: const Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            iconSize: 14,
            iconDisabledColor: Colors.grey,
            buttonHeight: 50,
            buttonWidth: 160,
            buttonPadding: const EdgeInsets.only(left: 14, right: 14),

            buttonElevation: 2,
            itemHeight: 40,
            itemPadding: const EdgeInsets.only(left: 14, right: 14),
            dropdownMaxHeight: 200,
            dropdownWidth: 200,
            dropdownPadding: null,

            dropdownElevation: 8,
            scrollbarRadius: const Radius.circular(40),
            scrollbarThickness: 6,
            scrollbarAlwaysShow: true,
            offset: const Offset(-20, 0),
          ),
        ),
      ],
    );
  }
}

class AssetCard extends GetView<AssetsController> {
  AssetCard({Key? key}) : super(key: key);

  final wc = Get.find<WalletService>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.clickAsset();
      },
      child: Container(
        height: 160.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wallet_card_bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
              title: const Text(
                'Wallet Name',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              subtitle: Obx(() => Text(
                    wc.current.value?.name ?? 'Wallet',
                    style:
                        const TextStyle(fontSize: 12.0, color: Colors.white70),
                  )),
              // subtitle: Obx(() => Text(controller.value.name ?? '')),
              trailing: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: const Text(
                'Total Balance',
                style: TextStyle(fontSize: 12.0, color: Colors.white),
              ),
              subtitle: Row(
                children: [
                  Obx(() => Text(
                        (controller.wtcAmount.value).toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 24.0, color: Colors.white),
                      )),
                  const SizedBox(width: 8.0),
                  const Text('USD',
                      style: TextStyle(fontSize: 14.0, color: Colors.white)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    required this.bgColor,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final Color bgColor;
  final IconData icon;
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: bgColor,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10.0),
            elevation: 0,
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.black,
          ),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
      ],
    );
  }
}

class Buttons extends GetView<AssetsController> {
  const Buttons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyButton(
            bgColor: pink,
            icon: Icons.arrow_upward,
            label: 'Send',
            onPressed: () {
              controller.clickSend();
            },
          ),
          MyButton(
            bgColor: green,
            icon: Icons.arrow_downward,
            label: 'Receive',
            onPressed: () {
              controller.clickReceive();
            },
          ),
        ],
      ),
    );
  }
}

class WTCToken extends GetView<AssetsController> {
  const WTCToken({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Get.toNamed('/token_detail', arguments: {'token': 'WTC'});
        controller.clickWtc();
      },
      child: Container(
        padding: const EdgeInsets.only(top: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/wtc.png',
                  width: 32.0,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WTC',
                      style: TextStyle(color: Colors.black87),
                    ),
                    Obx(() => Text(
                        r'$' + controller.wtcPrice.toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 12.0, color: Colors.black54))),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Obx(() => Text(
                      controller.wtcBalance.toStringAsFixed(2) + ' WTC',
                      style: const TextStyle(color: Colors.black87),
                    )),
                Obx(() => Text(r'$' + controller.wtcAmount.toStringAsFixed(2),
                    style: const TextStyle(
                        fontSize: 12.0, color: Colors.black54))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WTAToken extends GetView<AssetsController> {
  const WTAToken({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        controller.clickWta();
      },
      child: Container(
        padding: const EdgeInsets.only(top: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/wta.png',
                  width: 32.0,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'WTA',
                      style: TextStyle(color: Colors.black87),
                    ),
                    Text(r'$0.00',
                        style:
                            TextStyle(fontSize: 12.0, color: Colors.black54)),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Obx(() => Text(
                      controller.bs.url.value == baseUrls['WTC']
                          ? controller.wtaBalance.toStringAsFixed(2)
                          : controller.wtcBalance.toStringAsFixed(2) + ' WTA',
                      style: const TextStyle(color: Colors.black87),
                    )),
                Obx(() => controller.bs.url.value == baseUrls['WTC']
                    ? const Text(
                        r'$0.00',
                        style: TextStyle(fontSize: 12.0, color: Colors.black54),
                      )
                    : Text(
                        r'$' +
                            (controller.wtcAmount.value / 10)
                                .toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 12.0, color: Colors.black54),
                      )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Tokens extends GetView {
  Tokens({Key? key}) : super(key: key);

  final BlockchainService bs = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Total Assets',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
            // Icon(Icons.add_circle_outline),
          ],
        ),
        Obx(() => bs.url.value == baseUrls['WTC']
            ? const WTCToken()
            : const Text('')),
        const WTAToken(),
      ],
    );
  }
}
