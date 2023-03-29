import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

void errorSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    icon: Icon(Icons.error_outline, color: Colors.white),
    backgroundColor: Color(0xFFEF9A9A),
    snackPosition: SnackPosition.BOTTOM,
  );
}

void successSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    icon: Icon(Icons.celebration, color: Colors.white),
    backgroundColor: Color(0xFFA5D6A7),
    snackPosition: SnackPosition.BOTTOM,
  );
}

Future<String?> pickSingleFile() async {
  if (await Permission.storage.request().isGranted) {
    final results = await FilePicker.platform.pickFiles();

    if (results == null) {
      errorSnackbar('Error', 'Please pick a file');
    }
    return results?.files.single.path;
  }
  return null;
}
