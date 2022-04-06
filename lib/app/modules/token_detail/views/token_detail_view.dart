import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/component/back_bar.dart';
import 'package:wtc_wallet_app/app/data/models/utils.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';
import 'package:wtc_wallet_app/app/services/wallet_service.dart';

import '../controllers/token_detail_controller.dart';

class TokenDetailRow extends StatelessWidget {
  TokenDetailRow({
    Key? key,
    required this.from,
    required this.to,
    required this.hash,
    required this.time,
    required this.amount,
    required this.token,
  }) : super(key: key);

  final String from;
  final String to;
  final String hash;
  final String time;
  final double amount;
  final String token;

  final ws = Get.find<WalletService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Image.asset(
            'assets/images/${ws.current.value?.address == from ? 'in' : 'out'}.png',
            width: 20.0,
          ),
          const SizedBox(width: 12.0),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Utils.ellipsisedHash(hash)),
                  Image.asset(
                    'assets/images/copy.png',
                    width: 12.0,
                  ),
                ],
              ),
              Text(time),
            ],
          ),
          const Expanded(child: SizedBox()),
          Text('$amount $token'),
        ],
      ),
    );
  }
}

class TokenDetailView extends GetView<TokenDetailController> {
  TokenDetailView({Key? key}) : super(key: key);

  final wc = Get.find<WalletService>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const BackBar(title: 'Token Detail'),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Image.asset(
                    'assets/images/${controller.token}.png',
                    width: 40,
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    '${controller.token}',
                    style: const TextStyle(fontSize: 14.0),
                  )
                ],
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                // margin: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Balance'),
                    Text(controller.balance.toStringAsFixed(4))
                  ],
                ),
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        controller.showTotal();
                      },
                      child: const Text('Total'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    TextButton(
                      onPressed: () {
                        controller.showIn();
                      },
                      child: const Text('In'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    TextButton(
                      onPressed: () {
                        controller.showOut();
                      },
                      child: const Text('Out'),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: Obx(() => ListView.builder(
                    itemCount: controller.transactions.length,
                    itemBuilder: (context, index) {
                      return TokenDetailRow(
                        from: controller.transactions[index].from,
                        to: controller.transactions[index].to,
                        hash: controller.transactions[index].hash,
                        time: controller.transactions[index].time,
                        amount: controller.transactions[index].amount,
                        token: controller.transactions[index].token,
                      );
                    })),
              ),
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.SEND);
                    },
                    child: Container(
                      width: 130,
                      height: 48,
                      alignment: Alignment.center,
                      child: const Text('transfer'),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromRGBO(87, 212, 170, 1))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.RECEIVE);
                    },
                    child: Container(
                      width: 130,
                      height: 48,
                      alignment: Alignment.center,
                      child: const Text('Collect'),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromRGBO(130, 0, 255, 1))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
