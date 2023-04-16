import 'package:get/get.dart';

import '../../app/services/location_service.dart';
import '../../shared/controllers/user_controller.dart';
import '../../shared/repositories/service_repository.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  HomeController() {
    LocationService.instance.getLocationPermission();
    ServiceRepository.instance
        .getServicesStream(UserController.instance.user.value.email, true);
    ServiceRepository.instance
        .getServicesStream(UserController.instance.user.value.email, false);
  }
}
