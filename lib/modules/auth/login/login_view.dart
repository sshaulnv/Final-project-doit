import 'package:doit_app/modules/auth/login/login_controller.dart';
import 'package:doit_app/modules/auth/signup/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../shared/constants/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      backgroundColor: Color(0x88171717),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome!',
              style: kTextStyleWhiteHeader,
            ),
            SizedBox(height: 40),
            TextField(
              controller: LoginController.instance.emailController,
              keyboardType: TextInputType.emailAddress,
              style: kTextStyleTextFiled,
              decoration: kTextFieldInputDecoration.copyWith(
                prefixIcon: const Icon(
                  Icons.alternate_email,
                  color: kColorBlueText,
                ),
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: LoginController.instance.passwordController,
              obscureText: true,
              style: kTextStyleTextFiled,
              decoration: kTextFieldInputDecoration.copyWith(
                prefixIcon: const Icon(
                  Icons.lock,
                  color: kColorBlueText,
                ),
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 30),
            RoundIconButton(
              color: kColorRoundButton,
              icon: const Icon(
                Icons.login,
                color: Colors.white,
              ),
              text: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                final email =
                    LoginController.instance.emailController.text.trim();
                final password =
                    LoginController.instance.passwordController.text.trim();
                LoginController.instance.loginUser(email, password);
              },
            ),
            SizedBox(height: 20),
            RoundIconButton(
              color: Colors.white,
              icon: const ImageIcon(
                AssetImage('assets/images/google_icon.png'),
                size: 24,
                color: Color(0xFF1976D2),
              ),
              text: const Text(
                'Google',
                style: TextStyle(
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onPressed: () {},
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Get.to(SignupScreen(), transition: Transition.native);
              },
              child: Text(
                'Signup',
                style: TextStyle(color: Colors.blue[300]),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot password?',
                style: TextStyle(color: Colors.blue[300]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
