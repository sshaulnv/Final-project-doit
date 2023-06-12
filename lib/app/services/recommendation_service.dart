import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit_app/app/services/location_service.dart';
import 'package:doit_app/shared/constants/service_status.dart';
import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:doit_app/shared/widgets/embedded_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../shared/models/service_model.dart';
import '../../shared/models/user_model.dart';
import '../utils.dart';

class RecommendationService extends GetxController {
  static RecommendationService get instance => Get.find();

  Future<List<ServiceModel>> filterServicesByDistance(
      List<ServiceModel> services) async {
    List<ServiceModel> res = [];
    final GeoPoint userLocation =
        await LocationService.instance.getCurrentPosition();
    for (ServiceModel service in services) {
      if (calculateDistance(userLocation, service.sourceAddress) <
          UserController.instance.user.value.preferredDistance) {
        res.add(service);
      }
    }
    return res;
  }

  List<ServiceModel> filterIrrelevantServices(
      List<ServiceModel> services, UserModel user) {
    services = services
        .where((service) =>
            service.consumer != user.email &&
            service.provider != user.email &&
            service.status == ServiceStatus.PENDING)
        .toList();
    return services;
  }

  Map<String, dynamic> servicesEmbedding(
      List<ServiceModel> services, UserModel user) {
    EmbeddedVector userPreferences = EmbeddedVector.fromUserPreferences(user);
    List<EmbeddedVector> servicesVectors = [];
    for (ServiceModel service in services) {
      servicesVectors.add(EmbeddedVector.fromService(service));
    }
    return {'user': userPreferences, 'services': servicesVectors};
  }

  Future<List<ServiceModel>> recommend(
      List<ServiceModel> services, UserModel user) async {
    List<ServiceModel> filteredServiceList =
        filterIrrelevantServices(services, user);
    Map<String, dynamic> embeddingResults =
        servicesEmbedding(filteredServiceList, user);
    List<int> recommendedServicesIndexes =
        EmbeddedVector.findMostSimilarVectors(
            embeddingResults['user'], embeddingResults['services'], 5);
    return filteredServiceList
        .where((service) => recommendedServicesIndexes
            .contains(filteredServiceList.indexOf(service)))
        .toList();
  }
}
