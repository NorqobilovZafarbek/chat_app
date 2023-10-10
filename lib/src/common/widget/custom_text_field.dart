import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    this.textInputType,
    this.textInputAction,
    required this.hintText,
    required this.isObscure,
    super.key,
  });

  final TextEditingController controller;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String hintText;
  final bool isObscure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        fillColor: Colors.grey[300],
        filled: true,
        hintText: hintText,
      ),
    );
  }
}
