import 'package:doit_app/modules/auth/signup/signup_controller.dart';
import 'package:doit_app/shared/constants/categories.dart';
import 'package:doit_app/shared/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../app/theme.dart';
import '../../../shared/constants/constants.dart';

const kRowButtonPadding = 3.0;
const kTitlePreferrenceStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25);
const kValuePreferrenceStyle = TextStyle(color: Colors.white, fontSize: 22);

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final controller = Get.put(SignupController());
  List items = List<String>.generate(10, (i) => 'Item $i');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteBackgroundColor,
      body: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10),
        child: SafeArea(
          child: Form(
            key: controller.formKey,
            child: Stepper(
              onStepContinue: () {
                setState(() {
                  controller.currentStep < 2 ? controller.currentStep++ : null;
                });
              },
              onStepCancel: () {
                setState(() {
                  controller.currentStep > 0 ? controller.currentStep-- : null;
                });
              },
              steps: [
                Step(
                  isActive: controller.currentStep == 0,
                  title: Text(
                    'Personal Details',
                    style: kTextStyleHeader.copyWith(fontSize: 20),
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'Sign-up',
                            style: kTextStyleHeader.copyWith(fontSize: 40),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        controller:
                            SignupController.instance.usernameController,
                        style: kTextStyleTextFiled,
                        decoration: kTextFieldInputDecoration.copyWith(
                          prefixIcon: const Icon(
                            Icons.person,
                            color: kColorBlueText,
                          ),
                          labelText: 'Username',
                        ),
                        validator: (String? value) {
                          if (!controller.isUsernameValid(value!)) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: SignupController.instance.emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: kTextStyleTextFiled,
                        decoration: kTextFieldInputDecoration.copyWith(
                          prefixIcon: const Icon(
                            Icons.alternate_email,
                            color: kColorBlueText,
                          ),
                          labelText: 'Email',
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter a email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller:
                            SignupController.instance.passwordController,
                        obscureText: true,
                        style: kTextStyleTextFiled,
                        decoration: kTextFieldInputDecoration.copyWith(
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: kColorBlueText,
                          ),
                          labelText: 'Password',
                        ),
                        validator: (String? value) {
                          if (!controller.isPasswordValid()) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller:
                            SignupController.instance.confirmPasswordController,
                        obscureText: true,
                        style: kTextStyleTextFiled,
                        decoration: kTextFieldInputDecoration.copyWith(
                          prefixIcon: const Icon(
                            Icons.lock_reset,
                            color: kColorBlueText,
                          ),
                          labelText: 'Confirm Password',
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password again';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "1. Username: only letters, numbers, or underscores.\n"
                                "length: 3 up to 16.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                "2. Password: only letters, numbers, or underscores.\n"
                                "length: 8 up to 32.\n"
                                "at least 1 lowercase letter.\n"
                                "at least 1 uppercase letter.\n"
                                "at least 1 number.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Step(
                  isActive: controller.currentStep == 1,
                  title: Text(
                    'Self Preferences',
                    style: kTextStyleHeader.copyWith(fontSize: 20),
                  ),
                  content: Column(
                    children: [
                      Text(
                        'Preferred Categories',
                        style: kTextStyleHeader.copyWith(fontSize: 25),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 30.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              controller.categoriesPreferences.values.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: kRowButtonPadding),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    controller.currentCategoryIndex = index;
                                  });
                                },
                                child: Text(
                                  controller.categoriesPreferences.keys
                                      .toList()[index]
                                      .toString(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Slider(
                        value: controller.categoriesPreferences.values
                            .toList()[controller.currentCategoryIndex],
                        min: 0,
                        max: 100,
                        label: controller.categoriesPreferences.values
                            .toList()[controller.currentCategoryIndex]
                            .round()
                            .toString(),
                        onChanged: (double value) {
                          setState(() {
                            controller.categoriesPreferences[
                                    convertCategoryToString(Categories.values[
                                        controller.currentCategoryIndex])] =
                                value.floorToDouble();
                          });
                        },
                      ),
                      Text(
                        controller.categoriesPreferences.values
                            .toList()[controller.currentCategoryIndex]
                            .floor()
                            .toString(),
                        style: kTextStyleHeader.copyWith(
                            fontSize: 22, fontWeight: FontWeight.w100),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Preferred Hours',
                        style: kTextStyleHeader.copyWith(fontSize: 25),
                      ),
                      RangeSlider(
                        values: controller.preferredHours,
                        min: 0,
                        max: 23,
                        labels: RangeLabels(
                          controller.preferredHours.start.round().toString(),
                          controller.preferredHours.end.round().toString(),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            controller.preferredHours = values;
                          });
                        },
                        activeColor: Colors.blue[700],
                        inactiveColor: Colors.blue[100],
                        semanticFormatterCallback: (double values) {
                          return '${controller.preferredHours.start.round()} - ${controller.preferredHours.end.round()}';
                        },
                      ),
                      Text(
                        '${controller.preferredHours.start.floor()}:00 - ${controller.preferredHours.end.floor()}:00',
                        style: kTextStyleHeader.copyWith(
                            fontSize: 22, fontWeight: FontWeight.w100),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Preferred Prices',
                        style: kTextStyleHeader.copyWith(fontSize: 25),
                      ),
                      RangeSlider(
                        values: controller.preferredPrice,
                        min: 1,
                        max: kMaximumPrice.toDouble(),
                        divisions: kMaximumPrice,
                        labels: RangeLabels(
                          controller.preferredPrice.start.round().toString(),
                          controller.preferredPrice.end.round().toString(),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            controller.preferredPrice = values;
                          });
                        },
                        activeColor: Colors.blue[700],
                        inactiveColor: Colors.blue[100],
                        semanticFormatterCallback: (double values) {
                          return '${controller.preferredPrice.start.round()} - ${controller.preferredPrice.end.round()}';
                        },
                      ),
                      Text(
                        '${controller.preferredPrice.start.floor()} - ${controller.preferredPrice.end.floor()} ₪',
                        style: kTextStyleHeader.copyWith(
                            fontSize: 22, fontWeight: FontWeight.w100),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Preferred Distance',
                        style: kTextStyleHeader.copyWith(fontSize: 25),
                      ),
                      Slider(
                        value: controller.preferredDistance.toDouble(),
                        min: 0,
                        max: 300,
                        label: controller.preferredDistance.toString(),
                        onChanged: (double value) {
                          setState(() {
                            controller.preferredDistance = value.floor();
                          });
                        },
                      ),
                      Text(
                        '${controller.preferredDistance} Km',
                        style: kTextStyleHeader.copyWith(
                            fontSize: 22, fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                ),
                Step(
                  isActive: controller.currentStep == 2,
                  title: Text(
                    'Finish',
                    style: kTextStyleHeader.copyWith(
                        fontSize: 22, fontWeight: FontWeight.w100),
                  ),
                  content: Column(
                    children: [
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
                          if (controller.formKey.currentState!.validate()) {
                            controller.formKey.currentState!.save();
                            final user = UserModel(
                                username:
                                    controller.usernameController.text.trim(),
                                email: controller.emailController.text.trim(),
                                password:
                                    controller.passwordController.text.trim(),
                                categoriesPreferences:
                                    controller.categoriesPreferences,
                                preferredHours: controller.rangeValuesToMap(
                                        controller.preferredHours)
                                    as Map<String, int>,
                                preferredPrice: controller.rangeValuesToMap(
                                        controller.preferredPrice)
                                    as Map<String, int>);
                            SignupController.instance.registerUser(user);
                          } else {
                            setState(() {
                              controller.currentStep = 0;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
              onStepTapped: (int newIndex) {
                setState(() {
                  controller.currentStep = newIndex;
                });
              },
              currentStep: controller.currentStep,
              type: StepperType.vertical,
            ),
          ),
        ),
      ),
    );
  }
}
