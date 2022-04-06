import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackBar extends StatelessWidget {
  const BackBar({Key? key, this.onPress, required this.title})
      : super(key: key);

  final Function? onPress;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            if (onPress != null) {
              onPress!();
            } else {
              Get.back();
            }
          },
          icon: const Icon(Icons.arrow_back_ios),
          constraints: const BoxConstraints(),
          padding: EdgeInsets.zero,
        ),
        Text(title, style: const TextStyle(fontSize: 20.0)),
        const SizedBox(width: 20.0)
      ],
    );
  }
}
