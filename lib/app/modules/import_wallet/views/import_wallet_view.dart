import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/widgets/back_bar.dart';
import 'package:wtc_wallet_app/app/widgets/full_width_button.dart';
import 'package:wtc_wallet_app/app/widgets/input_text.dart';
import 'package:wtc_wallet_app/app/data/models/validator.dart';

import '../controllers/import_wallet_controller.dart';

class ImportWalletView extends GetView<ImportWalletController> {
  const ImportWalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackBar(title: 'Import Wallet'),
                const SizedBox(height: 16.0),
                InputText(
                  controller: controller.paste,
                  validator: Validator.wordsOrPrivateKey,
                  maxLines: 2,
                  hintText: 'Paste or type the private key or mnemonic',
                ),
                const SizedBox(height: 16.0),
                const Text('Name'),
                const SizedBox(height: 16.0),

                InputText(
                  controller: controller.name,
                  validator: Validator.name,
                  hintText: '2-12 characters',
                ),
                const SizedBox(height: 16.0),
                const Text('Password'),
                const SizedBox(height: 16.0),

                InputText(
                  controller: controller.pass,
                  validator: Validator.pass,
                  isPassword: true,
                  hintText: 'password',
                ),
                InputText(
                  controller: controller.passConfirm,
                  validator: (value) =>
                      Validator.passConfirm(value, controller.pass),
                  isPassword: true,
                  hintText: 'password confirm',
                ),
                const Expanded(child: SizedBox()),
                // const ImportButton(),
                FullWidthButton(
                  text: 'Import',
                  onPressed: () {
                    controller.clickImport();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
