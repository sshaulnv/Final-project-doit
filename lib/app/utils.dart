import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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

double calculateDistance(GeoPoint point1, GeoPoint point2) {
  double lat1 = point1.latitude;
  double lon1 = point1.longitude;
  double lat2 = point2.latitude;
  double lon2 = point2.longitude;
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

TimeOfDay timestampToTimeOfDay(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
}

Timestamp timeOfDayToTimestamp(TimeOfDay timeOfDay) {
  DateTime now = DateTime.now();
  DateTime dateTime =
      DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  return Timestamp.fromDate(dateTime);
}
