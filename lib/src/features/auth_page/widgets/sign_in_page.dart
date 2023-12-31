import 'package:chat_app/src/features/auth_page/services/auth_service.dart';
import 'package:chat_app/src/features/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sign_up_page.dart';
import '../../../common/widget/custom_button.dart';
import '../../../common/widget/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() async {
    ScaffoldMessenger.of(context).clearSnackBars();
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false);
    } catch (e) {
      String? message;
      if (e.toString() == 'Exception: channel-error') {
        message = 'Fill in the fields';
      } else if (e.toString() == 'Exception: INVALID_LOGIN_CREDENTIALS') {
        message = 'Incorrect data is entered or the account is not registered';
      } else if (e.toString() == 'Exception: invalid-email') {
        message = 'Invalid email';
      } else if (e.toString() == 'Exception: too-many-requests') {
        message = 'Too many requests';
      } else {
        message = e.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.telegram,
                  color: Colors.blueAccent,
                  size: 150,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Welcome back to Chat App!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                CustomTextField(
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  hintText: 'Email',
                  isObscure: false,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  hintText: 'Password',
                  isObscure: true,
                ),
                const SizedBox(height: 25),
                CustomButton(
                  onPressed: signIn,
                  text: 'Sign In',
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ));
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
