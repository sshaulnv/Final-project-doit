import 'package:doit_app/modules/auth/signup/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../shared/constants/constants.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Scaffold(
      backgroundColor: kColorBackground,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                  TextFormField(
                    controller: SignupController.instance.usernameController,
                    style: kTextStyleTextFiled,
                    decoration: kTextFieldInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: kColorBlueText,
                      ),
                      labelText: 'Username',
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: SignupController.instance.emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: kTextStyleTextFiled,
                    decoration: kTextFieldInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.alternate_email,
                        color: kColorBlueText,
                      ),
                      labelText: 'Email',
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter a email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: SignupController.instance.passwordController,
                    obscureText: true,
                    style: kTextStyleTextFiled,
                    decoration: kTextFieldInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: kColorBlueText,
                      ),
                      labelText: 'Password',
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller:
                        SignupController.instance.confirmPasswordController,
                    obscureText: true,
                    style: kTextStyleTextFiled,
                    decoration: kTextFieldInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.lock_reset,
                        color: kColorBlueText,
                      ),
                      labelText: 'Confirm Password',
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password again';
                      }
                      return null;
                    },
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        SignupController.instance.registerUser(
                            controller.emailController.text.trim(),
                            controller.passwordController.text.trim());
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
