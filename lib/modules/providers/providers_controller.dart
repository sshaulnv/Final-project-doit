import 'package:doit_app/shared/constants/categories.dart';
import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:doit_app/shared/models/user_model.dart';
import 'package:get/get.dart';

class ProvidersController extends GetxController {
  static ProvidersController get instance => Get.find();
  UserModel user = UserController.instance.user.value;
  late List serviceList;
  late RxList filteredList;
  Map<String, dynamic> filters = {
    'Category': Categories.values.toList(),
  };

  void filteredServiceList() {
    filteredList.value = serviceList;
    filters.forEach((filter, value) {
      switch (filter) {
        case 'Category':
          filteredList = filteredList
              .where((service) => value.contains(service.category))
              .toList()
              .obs;
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
