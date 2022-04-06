import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wtc_wallet_app/app/component/back_bar.dart';
import 'package:wtc_wallet_app/app/component/bullet_text.dart';

import '../controllers/create_wallet_controller.dart';

class BackupWordsView extends GetView<CreateWalletController> {
  const BackupWordsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackBar(title: 'Backup Wallet'),
            const SizedBox(height: 32.0),
            const Title(),
            const SizedBox(height: 32.0),
            Words(
              words: controller.words.split(' '),
            ),
            const SizedBox(height: 32.0),
            const Tips(),
            const Expanded(child: SizedBox()),
            const CopyButton()
          ],
        ),
      )),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Backup mnemonic'),
        Text(
            'Please transcribe the mnemonic phrases in order to make sure the backup is correct'),
      ],
    );
  }
}

class Words extends StatelessWidget {
  const Words({Key? key, required this.words}) : super(key: key);

  final List<String> words;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        crossAxisCount: 3,
        childAspectRatio: 2.4,
      ),
      itemCount: 12,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(child: Text(words[index])),
        );
      },
      padding: EdgeInsets.zero,
    );
  }
}

class Tips extends StatelessWidget {
  const Tips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        BulletText(
          text:
              'Safely keep particles in a safe place that isolates the network.',
        ),
        SizedBox(height: 16.0),
        BulletText(
          text:
              'Do not share and store particles on the Internet, such as emails, photo albums, social applications, etc.',
        ),
      ],
    );
  }
}

class CopyButton extends GetView<CreateWalletController> {
  const CopyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(40)),
      onPressed: () {
        controller.clickCopy();
      },
      child: const Text('Copy and to home page'),
    );
  }
}
