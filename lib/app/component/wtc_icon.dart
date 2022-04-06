import 'package:flutter/material.dart';

class WtcIcon extends StatelessWidget {
  const WtcIcon({Key? key, required this.onPressed}) : super(key: key);

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset('assets/images/wtc.png'),
      iconSize: 36.0,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
