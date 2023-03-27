import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'app/routes.dart';

void main() {
  runApp(
    GetMaterialApp(
      initialRoute: Routes.homeScreen,
      getPages: getPages,
    ),
  );
}
