import 'package:doit_app/app/services/chat_service.dart';
import 'package:doit_app/app/services/location_service.dart';
import 'package:doit_app/shared/repositories/chat_repository.dart';
import 'package:doit_app/shared/repositories/service_repository.dart';
import 'package:doit_app/shared/repositories/storage_repository/storage_repository.dart';
import 'package:get/get.dart';
import '../../modules/screenController.dart';
import '../../shared/controllers/user_controller.dart';
import '../../shared/models/user_model.dart';
import '../../shared/repositories/user_repository.dart';
import '../services/recommendation_service.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // here we do all the injections (controllers etc...)

    Rx<UserModel> userModel =
        UserModel(username: '', email: '', password: '').obs;
    Get.put(UserController(user: userModel), permanent: true);
    Get.put(LocationService(), permanent: true);
    Get.put(StorageRepository(), permanent: true);
    Get.put(UserRepository(), permanent: true);
    Get.put(ServiceRepository(), permanent: true);
    Get.put(RecommendationService(), permanent: true);
    Get.put(ChatRepository(), permanent: true);
    Get.put(ChatService(), permanent: true);
    Get.put(ScreenController(), permanent: true);
  }
}
