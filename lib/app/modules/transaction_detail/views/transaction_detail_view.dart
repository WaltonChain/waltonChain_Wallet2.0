import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wtc_wallet_app/app/component/back_bar.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';

import '../controllers/transaction_detail_controller.dart';

class TransactionDetailCard extends GetView<TransactionDetailController> {
  const TransactionDetailCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343.0,
      // height: 448.0,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(children: [
        Positioned(
          child: FractionalTranslation(
            translation: const Offset(0, -0.5),
            child: Image.asset(
              'assets/images/successful.png',
              width: 110,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${controller.amount} WTC'),
            const Text('Successful '),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          children: const [
            Text('发款方'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(controller.from, style: const TextStyle(fontSize: 12.0)),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: controller.copyFrom,
            ),
          ],
        ),
        Row(
          children: const [
            Text('收款方'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(controller.to, style: const TextStyle(fontSize: 12.0)),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: controller.copyTo,
            ),
          ],
        ),
        Row(
          children: const [
            Text('哈希值'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Utils.ellipsisedHash(controller.hash),
                style: const TextStyle(fontSize: 12.0)),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: controller.copyHash,
            ),
          ],
        ),
        // const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('交易时间', style: TextStyle(fontSize: 12.0)),
            Text(controller.time)
          ],
        ),
        const SizedBox(height: 20.0),
        const Text('浏览器查询'),
        Linkify(
          text:
              'https://waltonchain.pro/#/transactions?hash=${controller.hash}',
          textAlign: TextAlign.center,
          onOpen: (link) async {
            if (await canLaunch(link.url)) {
              await launch(link.url);
            } else {
              throw 'Could not launch $link';
            }
          },
        )
      ]),
    );
  }
}

class TransactionDetailView extends GetView<TransactionDetailController> {
  const TransactionDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: BackBar(title: 'Transaction Details'),
          ),
          SizedBox(height: 90.0),
          TransactionDetailCard(),
        ],
      ),
    ));
  }
}
