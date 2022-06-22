import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/modules/assets/views/assets_view.dart';
import 'package:wtc_wallet_app/app/modules/dapp/views/dapp_view.dart';
import 'package:wtc_wallet_app/app/modules/me/views/me_view.dart';
import 'package:wtc_wallet_app/app/modules/otc/views/otc_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  static final _widgetOptions = [
    const AssetsView(),
    const DappView(),
    const OtcView(),
    const MeView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => _widgetOptions.elementAt(controller.index.value)),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.stop_circle),
                label: 'Assets',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view),
                label: 'Dapp',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.paid),
                label: 'OTC',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Me',
              ),
            ],
            currentIndex: controller.index.value,
            selectedItemColor: Colors.purple[700],
            onTap: (index) {
              controller.setIndex(index);
            },
            unselectedItemColor: Colors.black,
          )),
    );
  }
}
