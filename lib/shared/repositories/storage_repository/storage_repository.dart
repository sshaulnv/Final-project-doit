import 'dart:io';

import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class StorageRepository extends GetxController {
  static StorageRepository get instance => Get.find();

  final FirebaseStorage storage = FirebaseStorage.instance;
  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await storage.ref('profile_photos/$fileName').putFile(file);
    } on FirebaseException catch (e) {
      //TODO: CHANGE TO SNACKBAR WITH MSG
      print(e);
    }
  }

  Future<String> downloadURL(String fileName, String bucket) async {
    String downloadURL =
        await storage.ref('$bucket/$fileName').getDownloadURL();
    return downloadURL;
  }
}
