import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit_app/shared/constants/service_status.dart';
import 'package:get/get.dart';

import '../../app/utils.dart';
import '../models/offer_service_model.dart';
import '../models/service_model.dart';

class ServiceRepository extends GetxController {
  static ServiceRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  Stream<QuerySnapshot>? consumeServiceStream;
  Stream<QuerySnapshot>? provideServiceStream;
  // late final Rx<UserModel?> user;

  Future<void> createService(ServiceModel service) async {
    await _db
        .collection("Services")
        .add(service.toJson())
        .whenComplete(() => successSnackbar(
            'Congratulations!', 'Your Service has been created'))
        .catchError((error) {
      errorSnackbar('Error', 'Something went wrong.');
    });
  }

  Future<void> createOfferService(OfferServiceModel service) async {
    await _db
        .collection("OfferServices")
        .add(service.toJson())
        .whenComplete(() => successSnackbar(
            'Congratulations!', 'Your Service has been created'))
        .catchError((error) {
      errorSnackbar('Error', 'Something went wrong.');
    });
  }

  void getServicesStream(String userEmail, bool isConsumer) {
    if (isConsumer) {
      consumeServiceStream = _db
          .collection('Services')
          .where('consumer', isEqualTo: userEmail)
          .snapshots();
    } else {
      provideServiceStream = _db
          .collection('Services')
          .where('provider', isEqualTo: userEmail)
          .snapshots();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUserServices(
      String userEmail) {
    return _db
        .collection('Services')
        .where(Filter.or(
          Filter("consumer", isEqualTo: userEmail),
          Filter("provider", isEqualTo: userEmail),
        ))
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllOfferServices(
      String userEmail) {
    return _db
        .collection('OfferServices')
        .where("provider", isNotEqualTo: userEmail)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUserOfferServices(
      String userEmail) {
    return _db
        .collection('OfferServices')
        .where(
          "provider",
          isEqualTo: userEmail,
        )
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getServicesForMapSearch(
      String userEmail) {
    return _db
        .collection('Services')
        .where(Filter.and(
          Filter("consumer", isNotEqualTo: userEmail),
          Filter("provider", isNull: true),
        ))
        .snapshots();
  }

  // Future<List<ServiceModel>> getAllServices() async {
  //   final snapshots = await _db.collection("Services").get();
  //   final services =
  //       snapshots.docs.map((e) => ServiceModel.fromSnapshot(e)).toList();
  //   return services;
  // }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllServices() {
    return _db.collection("Services").snapshots();
  }

  void updateServiceStatus(String id, ServiceStatus status) {
    _db
        .collection('Services')
        .doc(id)
        .update({'status': convertStatusToString(status)})
        .whenComplete(
            () => successSnackbar('Nice Job!', 'The Status has been updated!'))
        .catchError((error) {
          errorSnackbar('Error', 'Something went wrong.');
        }); // <-- Updated data
  }

  void deleteOfferService(String id) {
    _db
        .collection('OfferServices')
        .doc(id)
        .delete()
        .whenComplete(
            () => successSnackbar('Nice Job!', 'The Status has been updated!'))
        .catchError((error) {
      errorSnackbar('Error', 'Something went wrong.');
    }); // <-- Updated data
  }

  void updateServiceProvide(String id, ServiceStatus status,
      String? providerEmail, String msgTitle, String msg) {
    _db
        .collection('Services')
        .doc(id)
        .update({
          'provider': providerEmail,
          'status': convertStatusToString(status)
        })
        .whenComplete(() => successSnackbar(msgTitle, msg))
        .catchError((error) {
          errorSnackbar('Error', 'Something went wrong.');
        }); // <-- Updated data
  }
}
