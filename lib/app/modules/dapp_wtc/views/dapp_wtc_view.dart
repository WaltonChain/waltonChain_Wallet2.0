import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/component/back_bar.dart';
import 'package:wtc_wallet_app/app/component/input_number.dart';
// import 'package:wtc_wallet_app/app/component/staking_input.dart';
import 'package:wtc_wallet_app/app/component/wtc_icon.dart';
import 'package:wtc_wallet_app/app/data/models/validator.dart';
import 'package:wtc_wallet_app/app/modules/dapp_wtc/controllers/staking_controller.dart';

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
            const Text('amount'),
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
            const Text('amount'),
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
        backgroundColor:
            MaterialStateProperty.all(const Color.fromRGBO(130, 0, 255, 1)),
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
        backgroundColor:
            MaterialStateProperty.all(const Color.fromRGBO(130, 0, 255, 1)),
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

class StakingForm extends GetView<StakingController> {
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
                  child: const Text('Get Reward')),
            ],
          )
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
              padding: EdgeInsets.all(16.0),
              child: BackBar(title: 'WTSwap'),
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
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: controller.tc,
                        children: const [
                          SwapForm(),
                          StakingForm(),
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
