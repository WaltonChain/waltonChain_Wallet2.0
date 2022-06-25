import 'package:flutter/material.dart';

class InputNumber extends StatelessWidget {
  const InputNumber({
    Key? key,
    required this.controller,
    required this.validator,
    this.hintText = '0',
    this.enabled = true,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String hintText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: InputBorder.none,
        hintText: hintText,
      ),
      enabled: enabled,
    );
  }
}
