import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';

import '../controllers/otc_controller.dart';

class OtcView extends GetView<OtcController> {
  const OtcView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(Routes.PLACE_ORDER);
                },
                icon: const Icon(Icons.abc),
                label: const Text('Place Order'),
              ),
              const Text('OTC'),
              ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(Routes.MY_ORDERS);
                  },
                  icon: const Icon(Icons.abc),
                  label: const Text('My Orders'))
            ],
          ),
          TabBar(
            controller: controller.tc,
            tabs: controller.myTabs,
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(fontSize: 24.0),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tc,
              children: const [
                BuyOrders(),
                SellOrders(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BuyOrders extends GetView<OtcController> {
  const BuyOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      itemBuilder: (context, index) {
        return const Order();
      },
      itemCount: 10,
    );
  }
}

class SellOrders extends GetView<OtcController> {
  const SellOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      itemBuilder: (context, index) {
        return const Order();
      },
      itemCount: 10,
    );
  }
}

class Order extends StatelessWidget {
  const Order({
    Key? key,
    this.hash = '0x00',
    this.amount = 0.0,
    this.limit = 0.0,
    this.price = 0.0,
  }) : super(key: key);

  final String hash;
  final double amount;
  final double limit;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(hash), const Text('1 WTA ≈ 0.08 WTC')],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Amount $amount WTC'), const Text('Price')],
          ),
          Text('Limit $limit WTA'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Guaranteed Amount $limit WTA'),
              ElevatedButton(onPressed: () {}, child: const Text('Buy'))
            ],
          )
        ],
      ),
    );
  }
}
