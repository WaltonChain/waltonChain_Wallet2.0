import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/models/otc_order.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
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
                    Get.toNamed(Routes.PLACE_RECORD);
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
    return Obx(() => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          itemBuilder: (context, index) {
            final order = controller.sellOrders[index];
            final obj = {
              'type': 'sell',
              'id': controller.sellIds[index].toInt(),
              'address': order[0].toString(),
              'wtaAmount': Utils.doubleFromWeiAmount(order[1]),
              'wtcAmount': Utils.doubleFromWeiAmount(order[2]),
            };
            return Order(order: OtcOrder.fromJson(obj));
          },
          itemCount: controller.sellOrders.length,
        ));
  }
}

class SellOrders extends GetView<OtcController> {
  const SellOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          itemBuilder: (context, index) {
            final order = controller.buyOrders[index];
            final obj = {
              'type': 'buy',
              'id': controller.buyIds[index].toInt(),
              'address': order[0].toString(),
              'wtaAmount': Utils.doubleFromWeiAmount(order[1]),
              'wtcAmount': Utils.doubleFromWeiAmount(order[2]),
            };
            return Order(order: OtcOrder.fromJson(obj));
          },
          itemCount: controller.buyOrders.length,
        ));
  }
}

class Order extends GetView<OtcController> {
  const Order({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OtcOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  order.address,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              const Text('1 WTA ≈ 0.08 WTC')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Amount ${order.wtcAmount} WTC'),
              const Text('Price')
            ],
          ),
          Text('Limit ${order.wtaAmount} WTA'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Guaranteed Amount ${order.wtaAmount} WTA'),
              ElevatedButton(
                  onPressed: () {
                    controller.clickBuy(order.id, BigInt.from(order.wtaAmount));
                  },
                  child: Text(order.type == 'buy' ? 'sell' : 'buy'))
            ],
          )
        ],
      ),
    );
  }
}
