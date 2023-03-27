import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
