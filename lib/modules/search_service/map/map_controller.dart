import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../shared/models/service_model.dart';
import '../../../shared/widgets/service_dialog.dart';

class SearchMapController extends GetxController {
  static SearchMapController get instance => Get.find();
  late LatLng currentPosition;
  TextEditingController searchController = TextEditingController();

  BitmapDescriptor markerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  List serviceList = [];
  Set<Marker> markersSet = {};
  late GoogleMapController googleMapController;

  void setMarkersSet(BuildContext context) {
    markersSet = {};
    for (ServiceModel service in serviceList!) {
      Marker marker = Marker(
        markerId: MarkerId(service.id!),
        infoWindow: InfoWindow(title: service.title),
        icon: markerIcon,
        position: LatLng(
            service.sourceAddress.latitude, service.sourceAddress.longitude),
        onTap: () {
          // Callback function for when the marker is tapped
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ServiceDialog(
                service: service,
                isConsumer: false,
              );
            },
          );
        },
      );
      markersSet!.add(marker);
    }
  }
}
