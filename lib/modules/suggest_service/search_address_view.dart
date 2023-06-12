import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit_app/modules/suggest_service/search_address_controller.dart';

import 'package:doit_app/modules/suggest_service/suggest_service_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

import '../../app/services/location_service.dart';
import '../../shared/constants/constants.dart';

class SearchAddress extends StatefulWidget {
  @override
  State<SearchAddress> createState() => SearchAddressState();
}

class SearchAddressState extends State<SearchAddress> {
  SearchAddressController controller = Get.put(SearchAddressController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Address'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.searchController,
                  onChanged: (value) {
                    if (controller.debounce?.isActive ?? false)
                      controller.debounce!.cancel();
                    controller.debounce =
                        Timer(const Duration(milliseconds: 1000), () {
                      if (value.isNotEmpty) {
                        LocationService.instance.autoCompleteSearch(value);
                      }
                    });
                  },
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (controller.searchController.text.isNotEmpty) {
                    var place = await LocationService.instance
                        .getPlace(controller.searchController.text);
                    if (place == null) {
                      return;
                    }
                    setState(() {
                      controller.tempDescription =
                          LocationService.instance.placeToAddressString(place);
                      goToPlace(place);
                    });
                  }
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: {controller.userMarker},
              initialCameraPosition: controller.userCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                SearchAddressController.instance.googleMapController
                    .complete(controller);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: saveAddress,
        label: const Text('Save Address'),
        icon: const Icon(Icons.save_alt),
      ),
    );
  }

  Future<void> goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController googleMapController =
        await SearchAddressController.instance.googleMapController.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(lat, lng),
        zoom: kMapCameraZoom,
      ),
    ));

    controller.userMarker = Marker(
        markerId: const MarkerId('areaMarker'),
        infoWindow: const InfoWindow(title: 'Area'),
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(lat, lng));
  }

  void saveAddress() {
    final GeoPoint addressGeoPoint = GeoPoint(
        controller.userMarker.position.latitude,
        controller.userMarker.position.longitude);

    SuggestServiceController.instance.area = addressGeoPoint;
    SuggestServiceController.instance.areaDescription.value =
        controller.tempDescription!;

    Get.back();
  }

  Future<void> goToCurrentPosition() async {
    final GoogleMapController controller =
        await SearchAddressController.instance.googleMapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        SearchAddressController.instance.userCameraPosition));
  }
}
