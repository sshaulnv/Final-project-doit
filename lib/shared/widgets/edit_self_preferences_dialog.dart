import 'package:doit_app/shared/constants/categories.dart';
import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:flutter/material.dart';
import '../../modules/auth/signup/signup_view.dart';
import '../constants/constants.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

const kTitleStyle =
    TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25);
const kValueStyle = TextStyle(color: Colors.black, fontSize: 22);

class EditSelfPreferencesDialog extends StatefulWidget {
  @override
  EditSelfPreferencesDialogState createState() =>
      EditSelfPreferencesDialogState();
}

class EditSelfPreferencesDialogState extends State<EditSelfPreferencesDialog> {
  UserModel user = UserController.instance.user.value.clone();
  String currentCategory = convertCategoryToString(Categories.values[0]);

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
                    Icons.category,
                    size: 70,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Preferred Categories',
                  style: kTitleStyle,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 30.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: user.categoriesPreferences.keys.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: kRowButtonPadding),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentCategory = user.categoriesPreferences.keys
                                  .toList()[index];
                            });
                          },
                          child: Text(
                            user.categoriesPreferences.keys
                                .toList()[index]
                                .toString(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Slider(
                  value: user.categoriesPreferences[currentCategory],
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: user.categoriesPreferences[currentCategory]
                      .round()
                      .toString(),
                  onChanged: (double value) {
                    setState(() {
                      user.categoriesPreferences[currentCategory] =
                          value.floorToDouble();
                    });
                  },
                ),
                Text(
                  user.categoriesPreferences[currentCategory]
                      .floor()
                      .toString(),
                  style: kValueStyle,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Preferred Hours',
                  style: kTitleStyle,
                ),
                RangeSlider(
                  values: RangeValues(user.preferredHours['start'] + .0,
                      user.preferredHours['end'] + .0),
                  min: 0,
                  max: 23,
                  labels: RangeLabels(
                    user.preferredHours['start'].round().toString(),
                    user.preferredHours['end'].round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      user.preferredHours['start'] = values.start.floor();
                      user.preferredHours['end'] = values.end.floor();
                    });
                  },
                  activeColor: Colors.blue[700],
                  inactiveColor: Colors.blue[100],
                  semanticFormatterCallback: (double values) {
                    return '${user.preferredHours['start'].round()} - ${user.preferredHours['end'].round()}';
                  },
                ),
                Text(
                  '${user.preferredHours['start'].floor()}:00 - ${user.preferredHours['end'].floor()}:00',
                  style: kValueStyle,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Preferred Prices',
                  style: kTitleStyle,
                ),
                RangeSlider(
                  values: RangeValues(user.preferredPrice['start'] + .0,
                      user.preferredPrice['end'] + .0),
                  min: 1,
                  max: kMaximumPrice.toDouble(),
                  divisions: kMaximumPrice,
                  labels: RangeLabels(
                    user.preferredPrice['start'].round().toString(),
                    user.preferredPrice['end'].round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      user.preferredPrice['start'] = values.start;
                      user.preferredPrice['end'] = values.end;
                    });
                  },
                  activeColor: Colors.blue[700],
                  inactiveColor: Colors.blue[100],
                  semanticFormatterCallback: (double values) {
                    return '${user.preferredPrice['start'].round()} - ${user.preferredPrice['end'].round()}';
                  },
                ),
                Text(
                  '${user.preferredPrice['start'].floor()} - ${user.preferredPrice['end'].floor()} ₪',
                  style: kValueStyle,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Preferred Distance',
                  style: kTitleStyle,
                ),
                Slider(
                  value: user.preferredDistance.toDouble(),
                  min: 0,
                  max: 300,
                  label: user.preferredDistance.toString(),
                  onChanged: (double value) {
                    setState(() {
                      user.preferredDistance = value.floor();
                    });
                  },
                ),
                Text(
                  '${user.preferredDistance} Km',
                  style: kValueStyle,
                ),
                SizedBox(
                  height: 15.0,
                ),
                RoundIconButton(
                    icon: const Icon(
                      Icons.verified,
                      color: Colors.white,
                    ),
                    text: const Text(
                      'Done',
                      style: kTitlePreferrenceStyle,
                    ),
                    onPressed: () {
                      user.preferredPrice['start'] =
                          user.preferredPrice['start'].floor();
                      user.preferredPrice['end'] =
                          user.preferredPrice['end'].floor();
                      UserRepository.instance.updateUserPreferences(
                          UserController.instance.user.value.id!, user);
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
