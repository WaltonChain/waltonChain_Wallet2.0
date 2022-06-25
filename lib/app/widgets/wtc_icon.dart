import 'package:flutter/material.dart';

class WtcIcon extends StatelessWidget {
  const WtcIcon({Key? key, required this.onPressed, this.isWta = false})
      : super(key: key);

  final void Function()? onPressed;
  final bool isWta;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset('assets/images/${isWta ? 'wta' : 'wtc'}.png'),
      iconSize: 36.0,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
