import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as lo;

class StorageService extends GetxController {
  static StorageService get instance => Get.find();
  final ref = FirebaseStorage.instance.ref();
}
