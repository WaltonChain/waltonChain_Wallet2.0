import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/widgets/back_bar.dart';
import 'package:wtc_wallet_app/app/widgets/input_text.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
import 'package:wtc_wallet_app/app/data/models/validator.dart';
import 'package:wtc_wallet_app/app/data/services/wallet_service.dart';

import '../controllers/wallet_detail_controller.dart';

class WalletDetailView extends GetView<WalletDetailController> {
  WalletDetailView({Key? key}) : super(key: key);

  final wc = Get.find<WalletService>();
  final wallet = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: BackBar(title: 'Wallet Detail'),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: InkWell(
                onTap: () => controller.tapAddress(wallet),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Wallet Address',
                          style:
                              TextStyle(fontSize: 14.0, color: Colors.black87),
                        ),
                        const SizedBox(height: 4.0),
                        Text(wallet.address,
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.black54)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1.0),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Wallet Name',
                    style: TextStyle(fontSize: 14.0, color: Colors.black87),
                  ),
                  Row(
                    children: [
                      Text(
                        wallet.name,
                        style: const TextStyle(
                            fontSize: 14.0, color: Colors.black87),
                      ),
                      // const Icon(Icons.chevron_right),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            InkWell(
              onTap: () {
                Utils.customDialog(
                  title: 'Password',
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InputText(
                        controller: controller.pass,
                        validator: Validator.pass,
                        isPassword: true,
                        hintText: 'password',
                      ),
                    ],
                  ),
                  onCancel: () {
                    Get.back();
                    controller.pass.clear();
                  },
                  onConfirm: () {
                    Get.back();
                    controller.clickDialogConfirm(wallet);
                  },
                );
              },
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Export Private Key',
                      style: TextStyle(fontSize: 14.0, color: Colors.black87),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Utils.customDialog(
                      title: 'Are you sure to delete this wallet?',
                      content: const Text(''),
                      onConfirm: () {
                        Get.back();
                        // wc.del(wc.selectedIndex.value);
                        controller.confirmDelete(wallet);
                      });
                },
                child: Container(
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  child: const Text('Delete Wallet'),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
