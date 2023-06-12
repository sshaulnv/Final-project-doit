import 'package:doit_app/shared/constants/categories.dart';
import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:doit_app/shared/models/user_model.dart';
import 'package:get/get.dart';

import '../../shared/models/service_model.dart';

class HistoryController extends GetxController {
  static HistoryController get instance => Get.find();
  UserModel user = UserController.instance.user.value;
  late List serviceList;
  late RxList filteredList;
  Map<String, dynamic> filters = {
    'Category': Categories.values.toList(),
    'Provide': true.obs,
    'Consume': true.obs,
  };

  void filteredServiceList() {
    user = UserController.instance.user.value;
    filteredList.value = serviceList;
    filters.forEach((filter, value) {
      switch (filter) {
        case 'Category':
          filteredList = filteredList
              .where((service) => value.contains(service.category))
              .toList()
              .obs;

          break;
        case 'Consume':
        case 'Provide':
          for (ServiceModel service in filteredList.value) {
            print(service.provider);
            print(service.consumer);
          }
          if (filters['Provide'].value && filters['Consume'].value) {
            filteredList = filteredList
                .where((service) =>
                    service.provider == user.email ||
                    service.consumer == user.email)
                .toList()
                .obs;
          } else if (filters['Provide'].value) {
            filteredList = filteredList
                .where((service) => service.provider == user.email)
                .toList()
                .obs;
          } else if (filters['Consume'].value) {
            filteredList = filteredList
                .where((service) => service.consumer == user.email)
                .toList()
                .obs;
          } else {
            filteredList = [].obs;
          }
          break;
        default:
          {
            //statements;
          }
          break;
      }
    });
  }
}
