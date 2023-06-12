import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../repositories/user_repository.dart';

class EditPasswordDialog extends StatelessWidget {
  IconData iconData;
  String title;
  String msg;
  Function onPressed;
  TextEditingController textEditingController = TextEditingController();

  EditPasswordDialog(
      {required this.title,
      required this.msg,
      required this.iconData,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Ink(
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    iconData,
                    size: 70,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  msg,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  controller: textEditingController,
                  style: kTextStyleTextFiled,
                  decoration: kTextFieldInputDecoration.copyWith(
                    prefixIcon: Icon(
                      iconData,
                      color: kColorBlueText,
                    ),
                    labelText: title,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RoundIconButton(
                  icon: const Icon(
                    Icons.verified,
                    color: Colors.white,
                  ),
                  text: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    print(UserController.instance.user.value.email);
                    onPressed(UserController.instance.user.value.password,
                            textEditingController.text)
                        .then((status) {
                      if (status) {
                        UserRepository.instance.updateUserPassword(
                            UserController.instance.user.value.id!,
                            textEditingController.text);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
