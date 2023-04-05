import 'package:doit_app/shared/repositories/authentication_repository/authentication_repository.dart';
import 'package:doit_app/shared/repositories/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../shared/models/user_model.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();
  final userRepository = Get.put(UserRepository());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void registerUser(UserModel user) {
    AuthenticationRepository.instance
        .createUserWithEmailAndPassword(user.email, user.password);
    UserRepository.instace.createUser(user);
  }

  bool isUsernameValid(String username) {
    // Check if the username contains only letters, numbers, or underscores
    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
    if (!validCharacters.hasMatch(username)) {
      return false;
    }

    // Check if the username is between 3 and 16 characters long
    if (username.length < 3 || username.length > 16) {
      return false;
    }

    // If all validation checks pass, the username is valid
    return true;
  }

  bool isPasswordValid() {
    final String password = passwordController.text;
    // Check if the password is between 8 and 32 characters long
    if (password.length < 8 || password.length > 32) {
      return false;
    }

    // Check if the password contains at least one lowercase letter
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    if (!hasLowercase) {
      return false;
    }

    // Check if the password contains at least one uppercase letter
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    if (!hasUppercase) {
      return false;
    }

    // Check if the password contains at least one number
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    if (!hasNumber) {
      return false;
    }

    if (password != confirmPasswordController.text) {
      return false;
    }

    // If all validation checks pass, the password is valid
    return true;
  }
}
