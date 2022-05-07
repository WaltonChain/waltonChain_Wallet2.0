import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wtc_wallet_app/app/component/back_bar.dart';
import 'package:wtc_wallet_app/app/modules/staking/controllers/staking_controller.dart';

import '../controllers/staking_list_controller.dart';

class OrderCard extends StatelessWidget {
  OrderCard({Key? key, required this.order}) : super(key: key);

  final List order;
  final stakingController = Get.find<StakingController>();

  @override
  Widget build(BuildContext context) {
    final startTime = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime.fromMillisecondsSinceEpoch(order[1].toInt() * 1000));
    final status = order[2];
    final periodIndex = order[3].toInt();
    final period = stakingController.days[periodIndex];
    final amount = order[5] / BigInt.from(1e18);

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('Lock $period days'),
              const Expanded(child: SizedBox()),
              Text(status ? 'Staking' : 'Withdrawed'),
            ],
          ),
          const SizedBox(height: 4.0),
          const Divider(),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 8.0),
              Text(
                '$amount',
                style: const TextStyle(fontSize: 32.0),
              ),
              const Text('WTC')
            ],
          ),
          const SizedBox(height: 8.0),
          const Divider(
            thickness: 4.0,
            color: Color.fromRGBO(130, 0, 255, 1),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('$startTime Start'), Text('$period Days')],
          ),
        ],
      ),
    );
  }
}

class StakingListView extends GetView<StakingListController> {
  const StakingListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: BackBar(title: 'Staking Orders'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GetBuilder<StakingListController>(
                builder: (controller) => ListView.builder(
                  itemCount: controller.orders.length,
                  itemBuilder: (context, index) {
                    final order = controller.orders[index];
                    return OrderCard(order: order);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}