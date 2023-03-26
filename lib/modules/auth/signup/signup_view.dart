import 'package:flutter/material.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';

import '../../../shared/constants/constants.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'Sign-up',
                      style: kTextStyleWhiteHeader.copyWith(fontSize: 40),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: usernameController,
                  style: kTextStyleTextFiled,
                  decoration: kTextFieldInputDecoration.copyWith(
                    prefixIcon: const Icon(
                      Icons.person,
                      color: kColorBlueText,
                    ),
                    labelText: 'Username',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailController,
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
                  controller: passwordController,
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
                SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  style: kTextStyleTextFiled,
                  decoration: kTextFieldInputDecoration.copyWith(
                    prefixIcon: const Icon(
                      Icons.lock_reset,
                      color: kColorBlueText,
                    ),
                    labelText: 'Confirm Password',
                  ),
                ),
                SizedBox(height: 30),
                RoundIconButton(
                  color: kColorRoundButton,
                  icon: Icon(
                    Icons.verified,
                    color: Colors.white,
                  ),
                  text: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
