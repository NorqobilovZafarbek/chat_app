import 'package:chat_app/src/features/auth_page/widgets/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/widget/custom_button.dart';
import '../../../common/widget/custom_text_field.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  void signUp() async {
    if (passwordController.text != passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWhithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account has been created successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
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
                const SizedBox(height: 50),
                const Icon(
                  Icons.telegram,
                  color: Colors.lightBlueAccent,
                  size: 120,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Let\'s create an account for you!',
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
                  textInputAction: TextInputAction.next,
                  hintText: 'Password',
                  isObscure: true,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: passwordConfirmController,
                  textInputAction: TextInputAction.done,
                  hintText: 'Confirm password',
                  isObscure: true,
                ),
                const SizedBox(height: 25),
                CustomButton(
                  onPressed: signUp,
                  text: 'Sign Up',
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a member?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      },
                      child: const Text(
                        'Login now',
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
