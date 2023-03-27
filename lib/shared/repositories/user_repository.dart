import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../app/utils.dart';
import '../models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instace => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _db
        .collection("Users")
        .add(user.toJson())
        .whenComplete(() =>
            successSnackbar('Congratulations!', 'You are now part of DoIt!'))
        .catchError((error) {
      errorSnackbar('Error', 'Something went wrong.');
    });
  }
}
