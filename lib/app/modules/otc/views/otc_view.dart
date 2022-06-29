import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/core/values/colors.dart';
import 'package:wtc_wallet_app/app/data/models/otc_order.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';

import '../controllers/otc_controller.dart';

class OtcView extends GetView<OtcController> {
  const OtcView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(Routes.PLACE_ORDER);
                  },
                  icon: const Icon(
                    Icons.border_color,
                    size: 16.0,
                  ),
                  label: const Text('Place Order'),
                ),
                const Text(
                  'OTC',
                  style: TextStyle(fontSize: 24.0),
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(Routes.PLACE_RECORD);
                    },
                    icon: const Icon(
                      Icons.format_list_bulleted,
                      size: 16.0,
                    ),
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
            const Divider(),
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
      ),
    );
  }
}

class BuyOrders extends GetView<OtcController> {
  const BuyOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshOrders,
      child: Obx(() => ListView.builder(
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
          )),
    );
  }
}

class SellOrders extends GetView<OtcController> {
  const SellOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshOrders,
      child: Obx(() => ListView.builder(
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
          )),
    );
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  Utils.ellipsisedHash(order.address),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              Text(
                '1 WTA ≈ ${(order.wtcAmount / order.wtaAmount).toStringAsFixed(4)} WTC',
                style: const TextStyle(fontSize: 16.0),
              )
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount ${order.wtcAmount} WTC',
                style: const TextStyle(fontSize: 16.0),
              ),
              const Text(
                'Price',
                style: TextStyle(fontSize: 16.0),
              )
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            'Limit ${order.wtaAmount} WTA',
            style: const TextStyle(fontSize: 16.0),
          ),
          // const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Guaranteed Amount ${order.wtaAmount} WTA',
                style: const TextStyle(fontSize: 14.0),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.defaultDialog(
                      title: 'Confirm',
                      content: const Text('Are you sure to deal this order?'),
                      onCancel: () {},
                      onConfirm: () {
                        Get.back();
                        controller.clickDeal(order);
                      });
                },
                child: Text(order.type == 'buy' ? 'sell' : 'buy'),
                style: ElevatedButton.styleFrom(
                  primary: purple,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 4.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
