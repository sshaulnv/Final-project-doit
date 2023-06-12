import 'package:doit_app/modules/screenController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../shared/widgets/bottom_navigator.dart';

class ScreenContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigator(),
        body: Obx(
          () => ScreenController.instance.getScreen(),
        ));
  }
}
