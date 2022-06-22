import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/component/full_width_button.dart';
import 'package:wtc_wallet_app/app/component/input_number.dart';
import 'package:wtc_wallet_app/app/data/models/validator.dart';
import 'package:wtc_wallet_app/app/modules/assets/controllers/assets_controller.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';

import '../controllers/place_order_controller.dart';

class PlaceOrderView extends GetView<PlaceOrderController> {
  const PlaceOrderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Place'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Get.toNamed(Routes.PLACE_RECORD);
                },
                icon: const Icon(Icons.calendar_month))
          ],
        ),
        body: Column(
          children: [
            TabBar(
              controller: controller.tc,
              tabs: controller.tabs,
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(fontSize: 24.0),
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tc,
                children: [
                  BuyForm(),
                  SellForm(),
                ],
              ),
            ),
          ],
        ));
  }
}

class BuyForm extends GetView<PlaceOrderController> {
  BuyForm({Key? key}) : super(key: key);

  final AssetsController ac = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: controller.buyFormKey,
        child: ListView(
          children: [
            const Text(
              'Buy total price WTC',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 4.0),
            InputNumber(
              controller: controller.buyWtcPrice,
              validator: (value) =>
                  Validator.amount(value, ac.wtcBalance.value),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Buy total amount WTA',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 4.0),
            InputNumber(
              controller: controller.buyWtaAmount,
              validator: (value) => Validator.toAmount(value),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Price',
                  style: TextStyle(fontSize: 16.0),
                ),
                Obx(() => Text(
                      '1 WTC ≈ ${controller.buyPrice.toStringAsFixed(4)}',
                      style: const TextStyle(fontSize: 16.0),
                    )),
              ],
            ),
            const SizedBox(height: 16.0),
            FullWidthButton(
                onPressed: () {
                  controller.clickPlaceBuy();
                },
                text: 'Place')
          ],
        ),
      ),
    );
  }
}

class SellForm extends GetView<PlaceOrderController> {
  SellForm({Key? key}) : super(key: key);

  final AssetsController ac = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: controller.sellFormKey,
        child: ListView(
          children: [
            const Text(
              'Sell total price WTC',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 4.0),
            InputNumber(
              controller: controller.sellWtcPrice,
              validator: (value) => Validator.toAmount(value),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Sell total amount WTA',
              style: TextStyle(fontSize: 16.0),
            ),
            InputNumber(
              controller: controller.sellWtaAmount,
              validator: (value) => Validator.amount(value, ac.wtaAmount.value),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Price'),
                Obx(() => Text(
                      '1 WTC ≈ ${controller.sellPrice.toStringAsFixed(4)}',
                      style: const TextStyle(fontSize: 16.0),
                    )),
              ],
            ),
            const SizedBox(height: 16.0),
            FullWidthButton(
                onPressed: () {
                  controller.clickPlaceSell();
                },
                text: 'Place')
          ],
        ),
      ),
    );
  }
}
