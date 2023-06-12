import 'package:doit_app/modules/profile/profile_controller.dart';
import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:doit_app/shared/widgets/edit_password_dialog.dart';
import 'package:doit_app/shared/widgets/edit_self_preferences_dialog.dart';
import 'package:flutter/material.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../app/theme.dart';
import '../../shared/constants/constants.dart';
import '../../shared/repositories/authentication_repository/authentication_repository.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController controller = Get.put(ProfileController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.updatePhoto(UserController.instance.user.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteBackgroundColor,
      // bottomNavigationBar: BottomNavigator(screenIndex: 1),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: kBottomNavigatorTabBackgroundColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Obx(
                  () => Center(
                    child: controller.profileImage == null
                        ? Text(
                            UserController.instance.user.value!.username[0]
                                .toUpperCase(),
                            style:
                                TextStyle(color: Colors.black, fontSize: 130),
                          )
                        : CircleAvatar(
                            backgroundImage: controller.profileImage!.value,
                            backgroundColor: Colors.black,
                            radius: 96,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => Text(
                  UserController.instance.user.value!.username,
                  style:
                      kTextStyleHeader.copyWith(fontSize: 25, letterSpacing: 3),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => Text(
                  UserController.instance.user.value!.email,
                  style: kTextStyleHeader.copyWith(
                    fontSize: 25,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              RoundIconButton(
                icon: const Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                text: const Text(
                  'Edit Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditPasswordDialog(
                        title: 'Edit Password',
                        msg: 'Enter your new password in the text field',
                        iconData: Icons.password,
                        onPressed:
                            AuthenticationRepository.instance.editAuthPassword,
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              RoundIconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                text: const Text(
                  'Self Preferences',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditSelfPreferencesDialog();
                    },
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              RoundIconButton(
                icon: const Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                ),
                text: const Text(
                  'Edit Profile Photo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () async {
                  await controller.changeProfilePhoto();
                },
              ),
              const SizedBox(height: 20),
              RoundIconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                color: Colors.redAccent,
                text: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  AuthenticationRepository.instance.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
