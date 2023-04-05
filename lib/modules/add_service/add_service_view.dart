import 'package:doit_app/app/services/location_service.dart';
import 'package:doit_app/modules/add_service/search_address_view.dart';
import 'package:doit_app/shared/constants/categories.dart';
import 'package:doit_app/shared/constants/service_status.dart';
import 'package:doit_app/shared/models/service_model.dart';
import 'package:doit_app/shared/repositories/service_repository.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../app/utils.dart';
import '../../shared/constants/constants.dart';
import 'add_service_controller.dart';

class AddServiceScreen extends StatefulWidget {
  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final controller = Get.put(AddServiceController());
  @override
  void initState() {
    super.initState();
    var tempPosition = LocationService.instance.getCurrentPosition();
    tempPosition.then((resp) {
      controller.currentPosition = LatLng(resp.latitude, resp.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'New Service',
                      style: kTextStyleWhiteHeader.copyWith(fontSize: 40),
                    ),
                  ),
                ),
                TextFormField(
                  style: kTextStyleTextFiled,
                  decoration: kTextFieldInputDecoration.copyWith(
                    prefixIcon: const Icon(
                      Icons.title,
                      color: kColorBlueText,
                    ),
                    labelText: 'Service Title',
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description for your service request';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    controller.title = value!;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: kTextFieldInputDecoration.copyWith(
                    prefixIcon: const Icon(
                      Icons.category_rounded,
                      color: kColorBlueText,
                    ),
                    labelText: 'Service Category',
                    labelStyle: kTextStyleTextFiled,
                  ),
                  value: controller.category,
                  items: EnumToString.toList(Categories.values, camelCase: true)
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: kTextStyleTextFiled,
                      ),
                    );
                  }).toList(),
                  validator: (String? value) {
                    if (value == null) {
                      return 'Please select a category for your service request';
                    }
                    return null;
                  },
                  onChanged: (String? value) {
                    controller.category = value!;
                  },
                  onSaved: (String? value) {
                    controller.category = value!;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        controller.date = picked;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: kColorRoundButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    controller.date == null
                        ? 'Select Date'
                        : 'Date: ${controller.date.toString().substring(0, 10)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Obx(
                  () => RoundIconButton(
                    color: kColorRoundButton,
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    text: Text(
                      controller.sourceAddressDescription.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      Get.to(SearchAddress(
                        isSourceAddress: true,
                      ));
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Obx(
                  () => RoundIconButton(
                    color: kColorRoundButton,
                    icon: Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    text: Text(
                      controller.destAddressDescription.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      Get.to(() => SearchAddress(isSourceAddress: false));
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  style: kTextStyleTextFiled,
                  decoration: kTextFieldInputDecoration.copyWith(
                    labelText: 'Service Description',
                  ),
                  maxLines: 4,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description for your service request';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    controller.description = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  style: kTextStyleTextFiled,
                  decoration: kTextFieldInputDecoration.copyWith(
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      color: kColorBlueText,
                    ),
                    labelText: 'Service Price',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter a price for your service request';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    controller.price = int.parse(value!);
                  },
                ),
                const SizedBox(height: 16.0),
                RoundIconButton(
                  color: kColorRoundButton,
                  icon: const Icon(
                    Icons.verified,
                    color: Colors.white,
                  ),
                  text: const Text(
                    'Create Service',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      if (controller.date == null) {
                        errorSnackbar(
                            'Fill all fields!', 'The Date field is empty');
                        return;
                      }
                      controller.formKey.currentState!.save();
                      controller.newService = ServiceModel(
                          consumer: controller.consumer!,
                          title: controller.title!,
                          category:
                              convertStringToCategory(controller.category),
                          date: controller.date!,
                          sourceAddress: controller.sourceAddress!,
                          destAddress: controller.destAddress!,
                          description: controller.description!,
                          price: controller.price!,
                          status: ServiceStatus.PENDING);
                      ServiceRepository.instace
                          .createService(controller.newService);
                      print(controller.newService);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
