import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../shared/controllers/user_controller.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/repositories/authentication_repository/authentication_repository.dart';
import '../../../shared/repositories/user_repository.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    if (await AuthenticationRepository.instance
        .loginWithEmailAndPassword(email, password)) {
      dynamic userData = (await UserRepository.instace.getUserDetails(email));
      UserController.instance.user = UserModel(
              username: userData.username,
              email: userData.email,
              password: userData.password)
          .obs;
    }
  }
}
