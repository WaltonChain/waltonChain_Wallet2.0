import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/component/back_bar.dart';

import '../controllers/assets_overview_controller.dart';

class AssetsOverviewView extends GetView<AssetsOverviewController> {
  const AssetsOverviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: BackBar(title: 'Assets Overview'),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Container(
                    height: 160.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/wallet_card_bg.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(r'Total Balance($)'),
                            const SizedBox(width: 16.0),
                            IconButton(
                              icon: Obx(() => Icon(controller.visible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                              onPressed: () {
                                controller.toggleVisible();
                              },
                            ),
                          ],
                        ),
                        Obx(() => Text(controller.visible.value
                            ? controller.totalBalance.value.toStringAsFixed(4)
                            : '****')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // todo: search
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
