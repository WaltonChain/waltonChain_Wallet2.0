import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';

class AccountSheet extends StatelessWidget {
  const AccountSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        TextButton(
          onPressed: () {
            Get.toNamed(Routes.CREATE_WALLET);
          },
          child: const Text('Create new account'),
        ),
        TextButton(
          onPressed: () {
            Get.toNamed(Routes.IMPORT_WALLET);
          },
          child: const Text('Import wallet'),
        ),
      ],
    );
  }
}
