import 'package:doit_app/modules/auth/login/login_view.dart';
import 'package:doit_app/modules/home/home_view.dart';
import 'package:doit_app/shared/repositories/authentication_repository/exceptions/login_email_password_failure.dart';
import 'package:doit_app/shared/repositories/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../app/utils.dart';
import '../../controllers/user_controller.dart';
import '../../models/user_model.dart';

import '../user_repository.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      print(UserController.instance.user.value.email);
      if (UserController.instance.user.value.email.isEmpty) {
        dynamic userData =
            await UserRepository.instace.getUserDetails(user.email!);
        print(userData.preferredDistance);
        UserController.instance.user = UserModel(
          username: userData.username,
          email: userData.email,
          password: userData.password,
          categoriesPreferences: userData.categoriesPreferences,
          preferredHours: userData.preferredHours,
          preferredPrice: userData.preferredPrice,
          preferredDistance: userData.preferredDistance,
        ).obs;
      }
      Get.offAll(() => HomeScreen());
    }
  }

  Future<bool> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => HomeScreen())
          : Get.offAll(() => LoginScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignupWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      errorSnackbar('Signup Error!', ex.message);
      return false;
    } catch (_) {
      const ex = SignupWithEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');
      return false;
    }
    return true;
  }

  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = LoginWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      errorSnackbar('Login Error!', ex.message);
      return false;
    } catch (_) {
      const ex = LoginWithEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');
      return false;
    }
    return true;
  }

  Future<void> logout() async => await _auth.signOut();
}
