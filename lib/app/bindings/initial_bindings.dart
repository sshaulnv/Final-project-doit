import 'package:get/get.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // here we do all the injections (controllers etc...)
    // Get.put(AuthController(), permanent: true);
  }
}
