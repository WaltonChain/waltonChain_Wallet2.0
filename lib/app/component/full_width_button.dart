import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {
  const FullWidthButton({
    Key? key,
    this.height = 40,
    this.onPressed,
    this.text,
  }) : super(key: key);

  final double height;
  final void Function()? onPressed;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(height)),
      onPressed: onPressed,
      child: Text(text ?? ''),
    );
  }
}
