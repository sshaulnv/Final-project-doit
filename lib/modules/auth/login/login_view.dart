import 'package:doit_app/modules/auth/login/login_controller.dart';
import 'package:doit_app/modules/auth/signup/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../app/theme.dart';
import '../../../shared/constants/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteBackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome!',
                style: kTextStyleHeader,
              ),
              SizedBox(height: 40),
              TextFormField(
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
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter a email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
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
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              RoundIconButton(
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
                  if (controller.formKey.currentState!.validate()) {
                    controller.formKey.currentState!.save();
                    final email =
                        LoginController.instance.emailController.text.trim();
                    final password =
                        LoginController.instance.passwordController.text.trim();
                    LoginController.instance.loginUser(email, password);
                  }
                },
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  Get.to(SignupScreen(), transition: Transition.native);
                },
                child: Text(
                  'Signup',
                  style: TextStyle(color: Colors.blue[300]),
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return ForgotPasswordDialog();
              //       },
              //     );
              //   },
              //   child: Text(
              //     'Forgot password?',
              //     style: TextStyle(color: Colors.blue[300]),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
