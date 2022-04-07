import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/component/back_bar.dart';
import 'package:wtc_wallet_app/app/component/input_number.dart';
import 'package:wtc_wallet_app/app/component/input_text.dart';
import 'package:wtc_wallet_app/app/data/models/validator.dart';

import '../controllers/send_controller.dart';

class SendView extends GetView<SendController> {
  const SendView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              // padding: const EdgeInsets.symmetric(horizontal: 16.0),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: const BackBar(
                    title: 'Send',
                  ),
                ),
                const Text('To'),
                const SizedBox(height: 16.0),
                InputText(
                  controller: controller.addressInput,
                  validator: Validator.address,
                  hintText: 'Address',
                ),
                const SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Amount'),
                    Obx(() => Text(
                        '${controller.balance.toStringAsFixed(2)} ${controller.token.toUpperCase()}')),
                  ],
                ),
                const SizedBox(height: 10.0),
                InputNumber(
                  controller: controller.balanceInput,
                  validator: (value) =>
                      Validator.amount(value, controller.balance.value),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // sc.send();
                      controller.clickSwitch();
                    },
                    child: Obx(() => Text(
                          controller.token.value == 'wtc' ? 'WTA' : 'WTC',
                          style: const TextStyle(fontSize: 16.0),
                        )),
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(130, 0, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 16.0)),
                  ),
                ),
                const Expanded(child: SizedBox()),
                ElevatedButton(
                  onPressed: () {
                    // sc.send();
                    controller.clickSend();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    child: const Text('Next'),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(130, 0, 255, 1))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
