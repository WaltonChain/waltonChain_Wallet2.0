import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/core/utils/extensions.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(Routes.PLACE_ORDER);
                  },
                  icon: Icon(
                    Icons.border_color,
                    size: 16.0.sp,
                  ),
                  label: const Text('Place Order'),
                ),
                Text(
                  'OTC',
                  style: TextStyle(fontSize: 20.0.sp),
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(Routes.PLACE_RECORD);
                    },
                    icon: Icon(
                      Icons.format_list_bulleted,
                      size: 16.0.sp,
                    ),
                    label: const Text('My Orders'))
              ],
            ),
            TabBar(
              controller: controller.tc,
              tabs: controller.myTabs,
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(fontSize: 16.0.sp),
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
      padding: EdgeInsets.symmetric(vertical: 4.0.wp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  Utils.ellipsisedHash(order.address),
                  style: TextStyle(fontSize: 12.0.sp),
                ),
              ),
              Text(
                '1 WTA ≈ ${(order.wtcAmount / order.wtaAmount).toStringAsFixed(4)} WTC',
                style: TextStyle(fontSize: 12.0.sp),
              )
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount ${order.wtcAmount} WTC',
                style: TextStyle(fontSize: 12.0.sp),
              ),
              Text(
                'Price',
                style: TextStyle(fontSize: 12.0.sp),
              )
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            'Limit ${order.wtaAmount} WTA',
            style: TextStyle(fontSize: 12.0.sp),
          ),
          // const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Guaranteed Amount ${order.wtaAmount} WTA',
                style: TextStyle(fontSize: 12.0.sp),
              ),
              ElevatedButton(
                onPressed: () {
                  final rule1 = order.type == 'buy' &&
                      order.wtcAmount > controller.ac.wtcAmount.value;
                  final rule2 = order.type == 'sell' &&
                      order.wtaAmount > controller.ac.wtaAmount.value;

                  if (rule1 || rule2) {
                    Get.snackbar('Reject', 'Insufficient balance');
                  } else {
                    Get.defaultDialog(
                      title: 'Confirm',
                      content: const Text('Are you sure to deal this order?'),
                      onCancel: () {},
                      onConfirm: () {
                        Get.back();
                        controller.clickDeal(order);
                      },
                    );
                  }
                },
                child: Text(order.type == 'buy' ? 'sell' : 'buy'),
                style: ElevatedButton.styleFrom(
                  primary: purple,
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.0.wp, vertical: 2.0.wp),
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
