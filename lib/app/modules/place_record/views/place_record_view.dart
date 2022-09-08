import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/data/models/otc_order.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';

import '../controllers/place_record_controller.dart';

class PlaceRecordView extends GetView<PlaceRecordController> {
  const PlaceRecordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Records'),
        centerTitle: true,
      ),
      body: Obx(() => Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: ListView.builder(
              itemCount: controller.records.length,
              itemBuilder: (context, index) {
                final record = controller.records[index];
                final obj = {
                  'id': controller.ids[index].toInt(),
                  'type': record[4].toInt() == 1 ? 'Sell' : 'Buy',
                  'address': record[0].toString(),
                  'wtaAmount': Utils.doubleFromWeiAmount(record[1]),
                  'wtcAmount': Utils.doubleFromWeiAmount(record[2]),
                  'status': record[5].toInt() == 1 ? 'Completed' : 'Pending'
                };
                return Record(
                  order: OtcOrder.fromJson(obj),
                );
              },
            ),
          )),
    );
  }
}

class Record extends StatelessWidget {
  const Record({Key? key, required this.order}) : super(key: key);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Limit ${order.wtaAmount} WTA',
                style: const TextStyle(fontSize: 16.0),
              ),
              Text(
                order.status,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Guaranteed Amount ${order.wtaAmount} WTA',
                style: const TextStyle(fontSize: 14.0),
              ),
              Text(
                '${order.type} order',
                style: const TextStyle(fontSize: 12.0),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
