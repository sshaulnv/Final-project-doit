import 'package:doit_app/firebase_options.dart';
import 'package:doit_app/shared/repositories/authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'app/bindings/initial_bindings.dart';
import 'app/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));
  // InitialBindings().dependencies();
  runApp(
    GetMaterialApp(
      initialRoute: Routes.loginScreen,
      getPages: getPages,
    ),
  );
}
