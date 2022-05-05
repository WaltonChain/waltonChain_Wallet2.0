import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {
  const FullWidthButton({
    Key? key,
    this.height = 40,
    required this.onPressed,
    required this.text,
    this.bgColor = const Color.fromRGBO(130, 0, 255, 1),
  }) : super(key: key);

  final double height;
  final void Function()? onPressed;
  final String? text;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height),
        primary: bgColor,
      ),
      onPressed: onPressed,
      child: Text(text ?? ''),
    );
  }
}
