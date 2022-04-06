import 'package:flutter/material.dart';

class BulletText extends StatelessWidget {
  const BulletText({Key? key, required this.text}) : super(key: key);

  final String bullet = '\u2022';
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.fiber_manual_record,
          size: 16.0,
        ),
        const SizedBox(width: 32.0),
        Flexible(child: Text(text)),
      ],
    );
  }
}
