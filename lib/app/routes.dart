import 'package:doit_app/modules/add_service/add_service_view.dart';
import 'package:doit_app/modules/auth/login/login_view.dart';
import 'package:doit_app/modules/auth/signup/signup_view.dart';
import 'package:doit_app/modules/history/history_view.dart';
import 'package:doit_app/modules/profile/profile_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class Routes {
  static String loginScreen = '/login';
  static String signupScreen = '/signup';
  static String homeScreen = '/home';
  static String historyScreen = '/history';
  static String addNewServiceScreen = '/add_new_service';
  static String profileScreen = '/profile';
}

final getPages = [
  GetPage(
    name: Routes.loginScreen,
    page: () => LoginScreen(),
  ),
  GetPage(
    name: Routes.signupScreen,
    page: () => SignupScreen(),
  ),
  GetPage(
    name: Routes.historyScreen,
    page: () => HistoryScreen(),
  ),
  GetPage(
    name: Routes.addNewServiceScreen,
    page: () => AddServiceScreen(),
  ),
  GetPage(
    name: Routes.profileScreen,
    page: () => ProfileScreen(),
  ),
];
