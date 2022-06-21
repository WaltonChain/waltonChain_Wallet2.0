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
      body: Obx(() => ListView.builder(
            itemCount: controller.records.length,
            itemBuilder: (context, index) {
              final record = controller.records[index];
              final obj = {
                'id': controller.ids[index].toInt(),
                'type': record[4].toInt() == 1 ? 'Sell' : 'Buy',
                'address': record[0].toString(),
                'wtaAmount': Utils.doubleFromWeiAmount(record[1]),
                'wtcAmount': Utils.doubleFromWeiAmount(record[2])
              };
              return Record(
                order: OtcOrder.fromJson(obj),
              );
            },
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
              Text('1 WTA ≈ ${order.wtcAmount / order.wtaAmount} WTC')
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
            ],
          )
        ],
      ),
    );
  }
}
