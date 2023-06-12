import 'dart:io';

import 'package:doit_app/app/utils.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class StorageRepository extends GetxController {
  static StorageRepository get instance => Get.find();
  final FirebaseStorage storage = FirebaseStorage.instance;
  Future<void> uploadFile(String refPath, File file) async {
    try {
      final reference = FirebaseStorage.instance.ref(refPath);
      await reference.putFile(file);
    } on FirebaseException catch (e) {
      errorSnackbar('Error', 'We have some problems with uploading');
      print(e);
    }
  }

  Future<String> downloadURL(String fileName, String bucket) async {
    String downloadURL =
        await storage.ref('$bucket/$fileName').getDownloadURL();
    return downloadURL;
  }
}
