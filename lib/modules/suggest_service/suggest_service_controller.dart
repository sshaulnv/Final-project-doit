import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../shared/models/offer_service_model.dart';

class SuggestServiceController extends GetxController {
  static SuggestServiceController get instance => Get.find();
  late LatLng currentPosition;
  RxBool isCreate = true.obs;
  late List serviceList;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxString areaDescription = 'Area'.obs;
  String? title;
  String category = 'DELIVERIES';
  GeoPoint? area;
  String? description;
  int? startPrice;
  int? endPrice;

  late OfferServiceModel newService;
}
