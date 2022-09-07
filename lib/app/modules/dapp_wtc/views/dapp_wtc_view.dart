import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/core/values/colors.dart';
import 'package:wtc_wallet_app/app/widgets/back_bar.dart';
import 'package:wtc_wallet_app/app/widgets/full_width_button.dart';
import 'package:wtc_wallet_app/app/widgets/input_number.dart';
// import 'package:wtc_wallet_app/app/widgets/staking_input.dart';
import 'package:wtc_wallet_app/app/widgets/wtc_icon.dart';
import 'package:wtc_wallet_app/app/data/models/validator.dart';
import 'package:wtc_wallet_app/app/modules/dapp_wtc/controllers/stake_controller.dart';
import 'package:wtc_wallet_app/app/routes/app_pages.dart';

import '../controllers/swap_controller.dart';

class SwapCard extends GetView<SwapController> {
  const SwapCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(children: [
        Row(
          children: [
            const Text('Balance'),
            const SizedBox(width: 16.0),
            Obx(() => Text(controller.isWtcToWta.value
                ? controller.wtcBalance.toStringAsFixed(2) + ' WTC'
                : controller.wtaBalance.toStringAsFixed(2) + ' WTA')),
            const Expanded(child: SizedBox()),
            const Text('Amount'),
          ],
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Obx(() => WtcIcon(
                  onPressed: () {},
                  isWta: !controller.isWtcToWta.value,
                )),
            const SizedBox(width: 32.0),
            Obx(() => Text(controller.isWtcToWta.value ? 'WTC' : 'WTA')),
            Expanded(
              child: InputNumber(
                controller: controller.from,
                validator: (value) => Validator.amount(
                    value,
                    controller.isWtcToWta.value
                        ? controller.wtcBalance.value
                        : controller.wtaBalance.value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32.0),
        RotatedBox(
          quarterTurns: 1,
          child: IconButton(
              onPressed: () {
                controller.clickSwitch();
              },
              icon: Image.asset('assets/images/swap.png')),
        ),
        const SizedBox(height: 32.0),
        Row(
          children: [
            const Text('Balance'),
            const SizedBox(width: 16.0),
            Obx(() => Text(controller.isWtcToWta.value
                ? controller.wtaBalance.toStringAsFixed(2) + ' WTA'
                : controller.wtcBalance.toStringAsFixed(2) + ' WTC')),
            const Expanded(child: SizedBox()),
            const Text('Amount'),
          ],
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Obx(() => WtcIcon(
                  onPressed: () {},
                  isWta: controller.isWtcToWta.value,
                )),
            const SizedBox(width: 32.0),
            Obx(() => Text(controller.isWtcToWta.value ? 'WTA' : 'WTC')),
            Expanded(
                child: InputNumber(
              controller: controller.to,
              validator: Validator.toAmount,
            )),
          ],
        ),
      ]),
    );
  }
}

class TopButton extends GetView<SwapController> {
  const TopButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(40)),
        backgroundColor: MaterialStateProperty.all(purple),
      ),
      onPressed: () {
        controller.clickSwap();
      },
      child: const Text('Swap'),
    );
  }
}

class BottomButton extends GetView<SwapController> {
  const BottomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(40)),
        backgroundColor: MaterialStateProperty.all(purple),
      ),
      onPressed: () {
        // controller.swap();
      },
      child: const Text('Real-time mediation transaction'),
    );
  }
}

class SwapForm extends GetView<SwapController> {
  const SwapForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.swapFormKey,
      child: ListView(
        children: [
          const SwapCard(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // children: const [Text('Tolerance'), Text('5%')],
            ),
          ),
          const TopButton(),
          // const BottomButton(),
        ],
      ),
    );
  }
}

class StakingForm extends GetView<StakeController> {
  const StakingForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListView(
        children: [
          const Text('Available Vault Pool'),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/wtc.png', width: 40.0),
              Column(children: const [Text('Token'), Text('WTC')]),
              Column(children: [
                const Text('TVL'),
                Obx(() => Text(
                      controller.tvl.value.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 12.0),
                    ))
              ]),
              Column(children: [
                const Text('APR'),
                Obx(() => Text(
                      '${controller.apr.value.toStringAsFixed(2)} %',
                      style: const TextStyle(fontSize: 12.0),
                    ))
              ]),
            ],
          ),
          const SizedBox(height: 16.0),
          const Divider(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Your Balance'),
              Obx(() =>
                  Text(controller.balance.value.toStringAsFixed(2) + ' WTC')),
            ],
          ),
          const SizedBox(height: 16.0),
          Form(
            key: controller.stakeFormKey,
            child: InputNumber(
              controller: controller.stakeInput,
              validator: (value) =>
                  Validator.amount(value, controller.balance.value),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
              onPressed: () {
                controller.clickStake();
              },
              child: const Text('Stake')),
          const Divider(height: 8.0),
          const SizedBox(height: 16.0),
          Obx(() => Text('Staked: ${controller.staked.value} WTC')),
          const SizedBox(height: 16.0),
          Form(
            key: controller.withdrawFormKey,
            child: InputNumber(
              controller: controller.withdrawInput,
              validator: (value) =>
                  Validator.amount(value, controller.staked.value),
            ),
          ),
          const SizedBox(height: 8.0),

          // Obx(() => Text('rewards:${controller.rewards}')),
          const SizedBox(height: 8.0),
          ElevatedButton(
              onPressed: () {
                controller.clickWithdrawWtc();
              },
              child: const Text('Withdraw')),
          const Divider(height: 8.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Reward'),
                Obx(() =>
                    Text('${controller.profit.value.toStringAsFixed(2)} WTA'))
              ]),
              ElevatedButton(
                  onPressed: () {
                    controller.clickWithdrawProfit();
                  },
                  child: const Text('Harvest')),
            ],
          )
        ],
      ),
    );
  }
}

class StakingEntry extends GetView<StakeController> {
  const StakingEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(4)),
            title: const Text(
              'WTA Staking',
              style: TextStyle(fontSize: 24.0),
            ),
            subtitle:
                const Text('May 25, 2022', style: TextStyle(fontSize: 14.0)),
          ),
          const SizedBox(height: 16.0),
          const Text('Staking', style: TextStyle(fontSize: 18.0)),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Release Per Day 20000.0 WTA',
                  style: TextStyle(fontSize: 16.0),
                ),
                const Divider(
                  thickness: 1.0,
                  height: 16.0,
                ),
                Obx(() => Text(
                      'Personal Power ${controller.personalPower} PH/S',
                      style: const TextStyle(fontSize: 16.0),
                    )),
                const SizedBox(height: 16.0),
                Obx(() => Text(
                      'Total Power Online ${controller.totalPower} PH/S',
                      style: const TextStyle(fontSize: 16.0),
                    )),
                const SizedBox(height: 16.0),
                FullWidthButton(
                  onPressed: () {
                    Get.toNamed(Routes.STAKING);
                  },
                  text: 'Go Staking',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          const Text('Rewards', style: TextStyle(fontSize: 18.0)),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Rewards',
                  style: TextStyle(fontSize: 16.0),
                ),
                const Divider(
                  thickness: 1.0,
                  height: 16.0,
                ),
                Obx(() => Text(
                      controller.profit.toStringAsFixed(2) + ' WTA',
                      style: const TextStyle(fontSize: 16.0),
                    )),
                const SizedBox(height: 16.0),
                FullWidthButton(
                  onPressed: () {
                    controller.clickHarvest(controller.profit.value);
                  },
                  text: 'Harvest',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DappWtcView extends GetView<SwapController> {
  const DappWtcView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: BackBar(title: 'Staking'),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // const Text('waltonchain ......'),
                    const SizedBox(height: 16.0),
                    TabBar(
                      controller: controller.tc,
                      tabs: controller.myTabs,
                      labelColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: const TextStyle(fontSize: 24.0),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: controller.tc,
                        children: const [
                          // SwapForm(),
                          // StakingForm(),
                          StakingEntry(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
