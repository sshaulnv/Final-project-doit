import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit_app/app/services/location_service.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

import '../../../shared/constants/constants.dart';
import '../../../shared/constants/service_status.dart';
import '../../../shared/controllers/user_controller.dart';
import '../../../shared/models/service_model.dart';
import '../../../shared/repositories/service_repository.dart';
import 'map_controller.dart';

class SearchMap extends StatefulWidget {
  @override
  State<SearchMap> createState() => SearchMapState();
}

class SearchMapState extends State<SearchMap> {
  SearchMapController controller = Get.put(SearchMapController());
  late CameraPosition userCameraPosition;

  @override
  void initState() {
    super.initState();

    var tempPosition = LocationService.instance.getCurrentPosition();
    tempPosition.then((resp) {
      controller.currentPosition = LatLng(resp.latitude, resp.longitude);
      userCameraPosition = CameraPosition(
        target: controller.currentPosition,
        zoom: kMapCameraZoom,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Service'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: controller.searchController,
              )),
              IconButton(
                onPressed: () async {
                  if (controller.searchController.text.isNotEmpty) {
                    var place = await LocationService.instance
                        .getPlace(controller.searchController.text);
                    if (place == null) {
                      return;
                    }
                    setState(() {
                      goToPlace(place);
                    });
                  }
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: ServiceRepository.instance.getServicesForMapSearch(
                  UserController.instance.user.value.email),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (!snapshot.hasData && controller.serviceList.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var serviceDocs = snapshot.data!.docs;
                  controller.serviceList = [];
                  for (var doc in serviceDocs) {
                    controller.serviceList.add(ServiceModel.fromSnapshot(
                        doc as DocumentSnapshot<Map<String, dynamic>>));
                  }

                  controller.serviceList = controller.serviceList
                      .where((service) =>
                          service.status != ServiceStatus.COMPLETED)
                      .toList();
                  controller.setMarkersSet(context);
                  return Column(
                    children: [
                      Expanded(
                        child: GoogleMap(
                          mapType: MapType.normal,
                          markers: controller.markersSet,
                          initialCameraPosition: userCameraPosition,
                          onMapCreated: (GoogleMapController controller) {
                            SearchMapController.instance.googleMapController =
                                controller;
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    // final GoogleMapController googleMapController =
    //     await SearchMapController.instance.googleMapController.future;
    userCameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: kMapCameraZoom,
    );
    SearchMapController.instance.googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(userCameraPosition));
  }
}
