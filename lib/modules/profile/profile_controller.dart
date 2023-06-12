import 'dart:io';

import 'package:doit_app/shared/repositories/storage_repository/storage_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/controllers/user_controller.dart';
import '../../shared/models/user_model.dart';

class ProfileController extends GetxController {
  Rx<NetworkImage>? profileImage;

  Future<void> changeProfilePhoto() async {
    var result = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );
    print(result);
    if (result == null) return;
    final file = File(result.path);
    final filename = UserController.instance.user.value.uid;
    print(UserController.instance.user.value.uid);
    final refPath = '/profile_photos/$filename';
    await StorageRepository.instance.uploadFile(refPath, file);
    await updatePhoto(UserController.instance.user.value);
  }

  Future<void> updatePhoto(UserModel user) async {
    String photoPath = '/profile_photos/${user.uid}';
    final ref = StorageRepository.instance.storage.ref().child(photoPath);
    String url = '';
    try {
      url = await ref.getDownloadURL();
      // Use the URL to display the photo
    } catch (error) {
      if (error == 'storage/object-not-found') {
        print('Photo not found');
      } else {
        print('Error getting photo URL: $error');
      }
      print(url);
      profileImage = null;
      return;
    }

    if (profileImage == null) {
      profileImage = NetworkImage(url).obs;
    } else {
      profileImage!.value = NetworkImage(url);
    }
  }
}
