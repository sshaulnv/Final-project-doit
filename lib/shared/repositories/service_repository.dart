import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit_app/shared/constants/service_status.dart';
import 'package:get/get.dart';

import '../../app/utils.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';

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

  void updateServiceProvide(
      String id, ServiceStatus status, String providerEmail) {
    _db
        .collection('Services')
        .doc(id)
        .update({
          'provider': providerEmail,
          'status': convertStatusToString(status)
        })
        .whenComplete(() => successSnackbar('Cheers!', 'Do Your Best!'))
        .catchError((error) {
          errorSnackbar('Error', 'Something went wrong.');
        }); // <-- Updated data
  }
}
