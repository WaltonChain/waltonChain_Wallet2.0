import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/widgets/back_bar.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';

import '../controllers/transaction_record_controller.dart';

class Record extends StatelessWidget {
  const Record({
    Key? key,
    required this.amount,
    required this.token,
    required this.from,
    required this.to,
    required this.hash,
    required this.time,
    this.status,
  }) : super(key: key);

  final double amount;
  final String token;
  final String from;
  final String to;
  final String hash;
  final String time;
  final bool? status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(Routes.TRANSACTION_DETAIL, arguments: {
            'amount': amount,
            'token': token,
            'from': from,
            'to': to,
            'hash': hash,
            'time': time,
            'status': status,
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(token.toUpperCase()),
                Text(time),
              ],
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amount.toString(),
                ),
                Text(Utils.ellipsisedHash(hash)),
              ],
            ),
            const SizedBox(width: 16.0),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class TransactionRecordView extends GetView<TransactionRecordController> {
  const TransactionRecordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: BackBar(title: 'Transaction Record'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.records.length,
              itemBuilder: (context, index) {
                final record = controller.records[index];
                return Record(
                  amount: record.amount,
                  token: record.token,
                  from: record.from,
                  to: record.to,
                  hash: record.hash,
                  time: record.time,
                  status: record.status,
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
