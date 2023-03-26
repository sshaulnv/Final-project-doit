import 'package:flutter/material.dart';
import 'package:doit_app/round_icon_button.dart';

import 'shared/constants/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x88171717),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome!',
              style: kTextStyleWhiteHeader,
            ),
            SizedBox(height: 40),
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
            SizedBox(height: 30),
            RoundIconButton(
              color: kColorRoundButton,
              icon: Icon(
                Icons.login,
                color: Colors.white,
              ),
              text: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              onPressed: () {},
            ),
            SizedBox(height: 20),
            RoundIconButton(
              color: Colors.white,
              icon: const ImageIcon(
                AssetImage('images/google_icon.png'),
                size: 24,
                color: Color(0xFF1976D2),
              ),
              text: Text(
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
              onPressed: () {},
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
