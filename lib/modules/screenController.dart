import 'package:doit_app/modules/chat/chat_rooms_view.dart';
import 'package:doit_app/modules/history/history_view.dart';
import 'package:doit_app/modules/home/home_view.dart';
import 'package:doit_app/modules/profile/profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ScreenController extends GetxController {
  static ScreenController get instance => Get.find();
  RxInt currentScreenIndex = 0.obs;
  List<Widget> screens = [
    HomeScreen(),
    ProfileScreen(),
    HistoryScreen(),
    RoomsScreen(),
  ];

  Widget getScreen() {
    return screens[currentScreenIndex.value];
  }
}
