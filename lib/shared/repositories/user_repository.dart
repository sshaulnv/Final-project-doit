import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../app/utils.dart';
import '../models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
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

  void updateUserPassword(String id, String password) {
    _db
        .collection('Users')
        .doc(id)
        .update({'password': password})
        .whenComplete(
            () => successSnackbar('Success!', 'The password has been updated!'))
        .catchError((error) {
          errorSnackbar('Error', 'Something went wrong.');
        }); // <-- Updated data
  }

  void updateUserPreferences(String id, UserModel user) {
    _db
        .collection('Users')
        .doc(id)
        .update({
          'categoriesPreferences': user.categoriesPreferences,
          'preferredHours': user.preferredHours,
          'preferredPrice': user.preferredPrice,
          'preferredDistance': user.preferredDistance
        })
        .whenComplete(() =>
            successSnackbar('Success!', 'Your preferences has been updated!'))
        .catchError((error) {
          errorSnackbar('Error', 'Something went wrong.');
        }); // <-- Updated data
  }

  Future<void> updateUserRating(String email, double rating) async {
    var collection = await _db.collection('users').get();
    final userData = collection.docs
        .map((e) => e.data()["metadata"]!["email"] == email
            ? [e.id, e.data()["metadata"]!["rating"]]
            : null)
        .where((element) => element != null)
        .first;
    double newRating = userData![1] == 0 ? rating : (rating + userData![1]) / 2;
    _db
        .collection('users')
        .doc(userData![0])
        .update({
          'metadata': {"email": email, "rating": newRating},
        })
        .whenComplete(
            () => successSnackbar('Success!', 'Thanks for the ranking'))
        .catchError((error) {
          errorSnackbar('Error', 'Something went wrong.');
        });
  }
}
