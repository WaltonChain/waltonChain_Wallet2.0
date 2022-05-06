import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/component/back_bar.dart';

import '../controllers/staking_list_controller.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({Key? key, required this.order}) : super(key: key);

  final Map<String, dynamic> order;

  @override
  Widget build(BuildContext context) {
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
              Text('Lock ${order['days']} days'),
              const SizedBox(width: 20.0),
              Text('${order['amount']} WTC'),
              const Expanded(child: SizedBox()),
              const Text('Ended'),
            ],
          ),
          const SizedBox(height: 4.0),
          const Divider(),
          const SizedBox(height: 4.0),
          Row(
            children: const [
              Text('Total'),
              SizedBox(width: 8.0),
              Text('+ 4638.0347195 WTA')
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
            children: [
              Text('${order['startTime']} Start'),
              Text('${order['days']} Days')
            ],
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
