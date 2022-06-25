import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/widgets/back_bar.dart';
import 'package:wtc_wallet_app/app/widgets/full_width_button.dart';
import 'package:wtc_wallet_app/app/widgets/input_text.dart';
import 'package:wtc_wallet_app/app/data/models/validator.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';

import '../controllers/create_wallet_controller.dart';

class CreateWalletView extends GetView<CreateWalletController> {
  const CreateWalletView({Key? key}) : super(key: key);

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
                BackBar(
                  title: 'Create Wallet',
                  onPress: () => Get.offNamed(Routes.HOME),
                ),
                const SizedBox(height: 32.0),
                const Text('Name'),
                const SizedBox(height: 16.0),
                InputText(
                  controller: controller.name,
                  validator: Validator.name,
                  hintText: '2-12 characters',
                ),
                const SizedBox(height: 32.0),
                const Text('Password'),
                const SizedBox(height: 16.0),
                InputText(
                  controller: controller.pass,
                  validator: Validator.pass,
                  hintText: 'password',
                  isPassword: true,
                ),
                const Divider(height: 1.0),
                InputText(
                  controller: controller.passConfirm,
                  validator: (value) =>
                      Validator.passConfirm(value, controller.pass),
                  hintText: 'password confirm',
                  isPassword: true,
                ),
                const Expanded(child: SizedBox()),
                FullWidthButton(
                  text: 'Create',
                  onPressed: () {
                    controller.clickCreate();
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
