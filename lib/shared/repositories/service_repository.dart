import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../app/utils.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';

class ServiceRepository extends GetxController {
  static ServiceRepository get instace => Get.find();
  final _db = FirebaseFirestore.instance;
  // late final Rx<UserModel?> user;

  Future<void> createService(ServiceModel service) async {
    await _db
        .collection("Services")
        .add(service.toJson())
        .whenComplete(() => successSnackbar(
            'Congratulations!', 'Your Service has been created'))
        .catchError((error) {
      errorSnackbar('Error', 'Something went wrong.');
    });
  }

  // Future<UserModel> getUserDetails(String email) async {
  //   final snapshot =
  //       await _db.collection("Users").where("email", isEqualTo: email).get();
  //   final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
  //   return userData;
  // }
}
