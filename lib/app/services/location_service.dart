import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart' as gc;
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:location/location.dart';

class LocationService extends GetxController {
  static LocationService get instance => Get.find();
  final String key = '';

  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    print(json);
    if (json['status'] != 'ZERO_RESULTS') {
      var placeld = json['candidates'][0]['place_id'] as String;
      print(placeld);
      return placeld;
    }
    return '';
  }

  Future<Map<String, dynamic>?> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    if (placeId == '') {
      return null;
    }
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;
    print(placeToAddressString(results));
    return results;
  }

  String placeToAddressString(Map<String, dynamic> place) {
    final String city = place['address_components'][2]['short_name'];
    final String street = place['address_components'][1]['short_name'];
    final String streetNumber = place['address_components'][0]['short_name'];
    return '$city, $street, $streetNumber';
  }

  // Future<void> getLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     print('Location services are disabled.');
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       print('GPS permissions are denied.');
  //       return Future.error('GPS permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  // }
  //
  // Future<GeoPoint> getCurrentPosition() async {
  //   final Position position = await Geolocator.getCurrentPosition();
  //   return GeoPoint(position.latitude, position.longitude);
  // }

  Future<void> getLocationPermission() async {
    final Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionStatus;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permissionStatus == PermissionStatus.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<GeoPoint> getCurrentPosition() async {
    final Location location = Location();
    final LocationData locationData = await location.getLocation();
    return GeoPoint(locationData.latitude!, locationData.longitude!);
  }

  Future<gc.Placemark?> getAddressFromLocation(GeoPoint geoPoint) async {
    // use geocoding to get the address of the location
    List<gc.Placemark> placemarks = await gc.placemarkFromCoordinates(
        geoPoint!.latitude!, geoPoint!.longitude!);
    if (placemarks != null && placemarks.isNotEmpty) {
      return placemarks[0];
    }
    return null;
  }
}
