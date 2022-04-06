import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/component/icon_scan.dart';
import 'package:wtc_wallet_app/app/component/search.dart';
import 'package:wtc_wallet_app/app/component/wtc_icon.dart';

import '../controllers/dapp_controller.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: [
        Expanded(
          child: Search(),
        ),
        const SizedBox(
          width: 10.0,
        ),
        const IconScan()
      ]),
    );
  }
}

class DappView extends GetView<DappController> {
  const DappView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SearchBar(),
        const Divider(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                children: const [Text('My Dapp')],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  WtcIcon(
                    onPressed: () {
                      controller.clickDapp();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
