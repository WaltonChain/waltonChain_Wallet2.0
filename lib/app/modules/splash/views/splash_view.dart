import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/core/values/colors.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: splashBackground,
        child: Center(
          child: Image.asset(
            'assets/images/splash_logo.png',
            height: 70,
          ),
        ),
      ),
    );
  }
}
