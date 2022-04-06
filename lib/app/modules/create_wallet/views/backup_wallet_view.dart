import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/component/back_bar.dart';
import 'package:wtc_wallet_app/app/component/bullet_text.dart';
import '../controllers/create_wallet_controller.dart';

class BackupTips extends StatelessWidget {
  const BackupTips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Backup Tips'),
        SizedBox(height: 10.0),
        Text(
            'Obtaining a mnemonic is equivalent to having ownership of wallet assets'),
        SizedBox(height: 10.0),
        Divider(),
        SizedBox(height: 16.0),
        BulletText(
          text:
              'Anyone can transfer assets as long as they hold the private key and mnemonic.',
        ),
        SizedBox(height: 16.0),
        BulletText(
          text:
              'Anyone can transfer assets as long as they hold the private key and mnemonic.',
        ),
        SizedBox(height: 16.0),
        BulletText(
          text:
              'Anyone can transfer assets as long as they hold the private key and mnemonic.',
        ),
        SizedBox(height: 16.0),
        BulletText(
          text:
              'Anyone can transfer assets as long as they hold the private key and mnemonic.',
        ),
      ],
    );
  }
}

class NextButton extends GetView<CreateWalletController> {
  const NextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(40)),
      onPressed: () {
        controller.clickNext();
      },
      child: const Text('Next'),
    );
  }
}

class BackupWallet extends GetView<CreateWalletController> {
  const BackupWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const BackBar(title: 'Backup Wallet'),
              const SizedBox(height: 40.0),
              Image.asset('assets/images/backup_wallet.png', width: 97),
              const SizedBox(height: 50.0),
              const BackupTips(),
              const Expanded(child: SizedBox()),
              const NextButton(),
            ],
          ),
        ),
      ),
    );
  }
}
