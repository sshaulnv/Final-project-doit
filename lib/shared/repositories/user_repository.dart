import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../app/utils.dart';
import '../models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instace => Get.find();
  final _db = FirebaseFirestore.instance;
  // late final Rx<UserModel?> user;

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

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }
}
