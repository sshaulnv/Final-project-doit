import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'add_service_controller.dart';

class SearchAddressController extends GetxController {
  static SearchAddressController get instance => Get.find();
  Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();
  TextEditingController searchController = TextEditingController();
  String? tempDescription;
  Marker userMarker = Marker(
    markerId: const MarkerId('sourceAddressMarker'),
    infoWindow: const InfoWindow(title: 'Source Address'),
    icon: BitmapDescriptor.defaultMarker,
    position: AddServiceController.instance.currentPosition,
  );
  CameraPosition userCameraPosition = CameraPosition(
    target: AddServiceController.instance.currentPosition,
    zoom: 17,
  );
}
