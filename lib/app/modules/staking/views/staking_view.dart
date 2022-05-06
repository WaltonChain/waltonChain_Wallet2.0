import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/component/back_bar.dart';
import 'package:wtc_wallet_app/app/component/full_width_button.dart';
import 'package:wtc_wallet_app/app/component/input_number.dart';
import 'package:wtc_wallet_app/app/data/models/validator.dart';
import 'package:wtc_wallet_app/app/modules/dapp_wtc/controllers/stake_controller.dart';
import 'package:wtc_wallet_app/app/modules/dapp_wtc/controllers/swap_controller.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';

import '../controllers/staking_controller.dart';

class StakingView extends GetView<StakingController> {
  StakingView({Key? key}) : super(key: key);

  final sc = Get.find<SwapController>();
  final stc = Get.find<StakeController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: BackBar(title: 'Staking'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Staking Amount',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: Form(
                      key: controller.stakingFormKey,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: InputNumber(
                              controller: controller.stakingInput,
                              validator: (value) =>
                                  Validator.amount(value, sc.wtcBalance.value),
                              hintText: 'Amount',
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '*',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InputNumber(
                              enabled: false,
                              controller: controller.factorInput,
                              validator: Validator.stakeFactor,
                              hintText: 'Factor',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: Text(
                        'Available: ${sc.wtcBalance.toStringAsFixed(2)} WTC'),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      // scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                        crossAxisCount: 3,
                        childAspectRatio: 2.8,
                      ),
                      itemCount: controller.days.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            controller.setIndex(index);
                          },
                          child: Obx(() => Container(
                                decoration: BoxDecoration(
                                  color: index == controller.index.value
                                      ? const Color.fromRGBO(130, 0, 255, 1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: Center(
                                    child: Text(
                                        controller.days[index].toString() +
                                            ' days',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: index == controller.index.value
                                              ? Colors.white
                                              : Colors.black,
                                        ))),
                              )),
                        );
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Power: ${stc.personalPower.value} PH/S',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Total Power Online: ${stc.totalPower.value} PH/S',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 32),
                        FullWidthButton(
                          onPressed: () {
                            controller.clickConfirm();
                          },
                          text: 'Confirm',
                        ),
                        const SizedBox(height: 16.0),
                        FullWidthButton(
                          onPressed: () {
                            Get.toNamed(Routes.STAKING_LIST);
                          },
                          text: 'My Staking List',
                          bgColor: Colors.blue,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
