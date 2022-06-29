import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wtc_wallet_app/app/widgets/back_bar.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';

import '../controllers/transaction_detail_controller.dart';

class TransactionDetailCard extends GetView<TransactionDetailController> {
  const TransactionDetailCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: 448.0,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(children: [
        Image.asset(
          'assets/images/successful.png',
          width: 110,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${controller.amount} ${controller.token}'),
            const Text('Successful '),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          children: const [
            Text('From:'),
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
            Text('To:'),
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
            Text('Hash:'),
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
            const Text('Transaction Time:', style: TextStyle(fontSize: 12.0)),
            Text(controller.time)
          ],
        ),
        const SizedBox(height: 20.0),
        const Text('To Browser'),
        Linkify(
          text:
              'https://waltonchain.pro/#/transactions?hash=${controller.hash}',
          textAlign: TextAlign.center,
          onOpen: (link) async {
            if (await canLaunchUrl(Uri.parse(link.url))) {
              await launchUrl(Uri.parse(link.url));
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
