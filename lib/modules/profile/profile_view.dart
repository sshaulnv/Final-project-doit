import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:doit_app/shared/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../app/utils.dart';
import '../../shared/constants/constants.dart';
import '../../shared/repositories/authentication_repository/authentication_repository.dart';
import '../../shared/repositories/storage_repository/storage_repository.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    print(UserController.instance.user.value.username);
    return Scaffold(
      backgroundColor: kColorBackground,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    UserController.instance.user.value!.username[0]
                        .toUpperCase(),
                    style: TextStyle(color: Colors.black, fontSize: 130),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => Text(
                  UserController.instance.user.value!.username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => Text(
                  UserController.instance.user.value!.email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              RoundIconButton(
                color: kColorRoundButton,
                icon: const Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                text: const Text(
                  'Change Email',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {},
              ),
              SizedBox(height: 20),
              RoundIconButton(
                color: kColorRoundButton,
                icon: const Icon(
                  Icons.password,
                  color: Colors.white,
                ),
                text: const Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {},
              ),
              SizedBox(height: 20),
              RoundIconButton(
                color: Colors.redAccent[200],
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
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
