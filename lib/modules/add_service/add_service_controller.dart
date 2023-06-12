import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:doit_app/shared/models/service_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddServiceController extends GetxController {
  static AddServiceController get instance => Get.find();
  late LatLng currentPosition;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxString sourceAddressDescription = 'Source Address'.obs;
  RxString destAddressDescription = 'Destination Address'.obs;
  String? provider; // email
  String? consumer = UserController.instance.user.value.email; // email
  String? title;
  String category = 'DELIVERIES';
  DateTime? date;
  TimeOfDay? time;
  GeoPoint? sourceAddress;
  GeoPoint? destAddress;
  String? description;
  int? price;

  late ServiceModel newService;
}
