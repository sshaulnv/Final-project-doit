import 'package:get/get.dart';

import '../../shared/repositories/authentication_repository/authentication_repository.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // here we do all the injections (controllers etc...)
    Get.put(AuthenticationRepository(), permanent: true);
  }
}
