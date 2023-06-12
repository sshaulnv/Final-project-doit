import 'package:doit_app/modules/screenController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../app/theme.dart';

const HOME = 0;
const PROFILE = 1;
const HISTORY = 2;
const CHAT = 3;

class BottomNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBottomNavigatorBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: GNav(
            backgroundColor: kBottomNavigatorBackgroundColor,
            color: Colors.white,
            activeColor: kBottomNavigatorTextBackgroundColor,
            tabBackgroundColor: kBottomNavigatorTabBackgroundColor,
            gap: 8,
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(16),
            onTabChange: (index) {
              ScreenController.instance.currentScreenIndex.value = index;
              // switch (index) {
              //   case HOME:
              //     print("---HOME---");
              //     print("screenIndex=${screenIndex}");
              //     print("index=${index}");
              //     print("---------");
              //     Get.back();
              //     break;
              //   case PROFILE:
              //     print("---PROFILE---");
              //     print("screenIndex=${screenIndex}");
              //     print("index=${index}");
              //     print("---------");
              //     index = 0;
              //     if (screenIndex == HOME) {
              //       Get.to(() => ProfileScreen());
              //     } else {
              //       Get.off(() => ProfileScreen());
              //     }
              //     break;
              //   case HISTORY:
              //     print("---HISTORY---");
              //     print("screenIndex=${screenIndex}");
              //     print("index=${index}");
              //     print("---------");
              //     if (screenIndex == HOME) {
              //       Get.to(() => HistoryScreen());
              //     } else {
              //       Get.off(() => HistoryScreen());
              //     }
              //     break;
              //   case CHAT:
              //     if (screenIndex == HOME) {
              //       Get.to(() => RoomsScreen());
              //     } else {
              //       Get.off(() => RoomsScreen());
              //     }
              //     break;
              // }
            }, // navigation bar padding
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
              GButton(
                icon: Icons.list_alt_outlined,
                text: 'History',
              ),
              GButton(
                icon: Icons.chat,
                text: 'Chat',
              ),
            ]),
      ),
    );
  }
}
