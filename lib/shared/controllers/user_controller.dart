import 'package:get/get.dart';

import '../models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  late Rx<UserModel> user;
  UserController({required this.user});
}
