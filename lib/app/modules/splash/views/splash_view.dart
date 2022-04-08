import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(248, 244, 244, 1),
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
