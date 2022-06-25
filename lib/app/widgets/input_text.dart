import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  const InputText({
    Key? key,
    required this.controller,
    required this.validator,
    this.hintText,
    this.suffixIcon,
    this.isPassword = false,
    this.maxLines = 1,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final IconButton? suffixIcon;
  final bool isPassword;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
