import 'package:doit_app/modules/auth/login/login_view.dart';
import 'package:doit_app/modules/screenController.dart';
import 'package:doit_app/shared/repositories/authentication_repository/exceptions/edit_details_failure.dart';
import 'package:doit_app/shared/repositories/authentication_repository/exceptions/login_email_password_failure.dart';
import 'package:doit_app/shared/repositories/authentication_repository/exceptions/signup_email_password_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../app/utils.dart';
import '../../../modules/splash_screen/splash_screen.dart';
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
      if (UserController.instance.user.value.email.isEmpty) {
        dynamic userData =
            await UserRepository.instance.getUserDetails(user.email!);
        UserController.instance.user = UserModel(
          id: userData.id,
          uid: userData.uid,
          username: userData.username,
          email: userData.email,
          password: userData.password,
          categoriesPreferences: userData.categoriesPreferences,
          preferredHours: userData.preferredHours,
          preferredPrice: userData.preferredPrice,
          preferredDistance: userData.preferredDistance,
        ).obs;
      }
      Get.offAll(() => SplashScreen());
    }
  }

  Future<bool> createUserWithEmailAndPassword(UserModel user) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      if (firebaseUser.value != null) {
        UserModel newUser = user.clone();
        newUser.uid = firebaseUser.value!.uid;
        UserRepository.instance.createUser(newUser);
      } else {
        return false;
      }
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
    await FirebaseChatCore.instance.createUserInFirestore(
      types.User(
        firstName: user.username,
        id: firebaseUser.value!.uid, // UID from Firebase Authentication
        imageUrl: '',
        lastName: '',
        metadata: {'email': user.email, 'rating': 0.0},
      ),
    );
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

  Future<bool> editEmail(String newEmail) async {
    try {
      await firebaseUser.value!.updateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      final ex = EditDetailsFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      errorSnackbar('Edit Email Error!', ex.message);
      return false;
    } catch (_) {
      const ex = EditDetailsFailure();
      print('EXCEPTION - ${ex.message}');
      return false;
    }
    return true;
  }

  // Future<bool> editPassword(String newPassword) async {
  //   try {
  //     if (validatePassword(newPassword)) {
  //       await firebaseUser.value!.updatePassword(newPassword);
  //     } else {
  //       errorSnackbar(
  //           'Edit Password Error!', 'Password should be according to rules');
  //       return false;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     final ex = EditDetailsFailure.code(e.code);
  //     print('FIREBASE AUTH EXCEPTION - ${ex.message}');
  //     errorSnackbar('Edit Password Error!', ex.message);
  //     return false;
  //   } catch (_) {
  //     const ex = EditDetailsFailure();
  //     print('EXCEPTION - ${ex.message}');
  //     return false;
  //   }
  //   return true;
  // }

  Future<bool> editAuthPassword(
      String currentPassword, String newPassword) async {
    if (!validatePassword(newPassword)) {
      errorSnackbar(
          'Edit Password Error!', 'Password should be according to rules');
      return false;
    }
    //Create an instance of the current user.
    var user = await FirebaseAuth.instance.currentUser!;
    //Must re-authenticate user before updating the password. Otherwise it may fail or user get signed out.

    final cred = await EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(newPassword).then((_) {}).catchError((error) {
        print('FIREBASE AUTH EXCEPTION - ${error.message}');
        errorSnackbar('Edit Password Error!', error.message);
        return false;
      });
    }).catchError((error) {
      print('EXCEPTION - ${error.message}');
      errorSnackbar('Edit Password Error!', error.message);
      return false;
    });
    return true;
  }

  Future<void> logout() async {
    Rx<UserModel> userModel =
        UserModel(username: '', email: '', password: '').obs;
    UserController.instance.user = userModel;
    print('######## ${UserController.instance.user.value.email}');
    await _auth.signOut();
    ScreenController.instance.currentScreenIndex.value = 0;
  }

  bool validatePassword(String password) {
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

    // If all validation checks pass, the password is valid
    return true;
  }
}
