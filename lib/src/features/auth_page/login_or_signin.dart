import 'package:chat_app/src/features/auth_page/widgets/sign_in_page.dart';
import 'package:chat_app/src/features/auth_page/widgets/sign_up_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLogin = true;

  void changePages() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return const LoginPage();
    } else {
      return const RegisterPage();
    }
  }
}
