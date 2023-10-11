import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    this.textInputType,
    this.textInputAction,
    required this.hintText,
    required this.isObscure,
    this.isChat = false,
    super.key,
  });

  final bool isChat;
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
      minLines: 1,
      maxLines: isChat ? 6 : 1,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isChat ? Colors.transparent : Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2,
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
