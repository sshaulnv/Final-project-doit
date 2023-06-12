import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit_app/modules/suggest_service/search_address_view.dart';
import 'package:doit_app/modules/suggest_service/suggest_service_controller.dart';
import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:doit_app/shared/models/offer_service_model.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../app/services/location_service.dart';
import '../../app/theme.dart';
import '../../shared/constants/categories.dart';
import '../../shared/constants/constants.dart';
import '../../shared/repositories/service_repository.dart';
import '../../shared/widgets/offer_service_dialog.dart';
import '../../shared/widgets/round_icon_button.dart';

class SuggestServiceScreen extends StatefulWidget {
  @override
  SuggestServiceScreenState createState() => SuggestServiceScreenState();
}

class SuggestServiceScreenState extends State<SuggestServiceScreen> {
  final controller = Get.put(SuggestServiceController());

  @override
  void initState() {
    var tempPosition = LocationService.instance.getCurrentPosition();
    tempPosition.then((resp) {
      controller.currentPosition = LatLng(resp.latitude, resp.longitude);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundIconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    text: const Text(
                      'Create\nService',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      controller.isCreate.value = true;
                      print(controller.isCreate.value);
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RoundIconButton(
                    icon: const Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    text: const Text(
                      'Your\nServices',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      controller.isCreate.value = false;
                      print(controller.isCreate.value);
                    },
                  )
                ],
              ),
              Obx(
                () => Container(
                  child: controller.isCreate.value
                      ? Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: Text(
                                    'Suggest Service',
                                    style:
                                        kTextStyleHeader.copyWith(fontSize: 40),
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
                                items: EnumToString.toList(Categories.values,
                                        camelCase: true)
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
                              const SizedBox(height: 16.0),
                              Obx(
                                () => RoundIconButton(
                                  icon: const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                  text: Text(
                                    controller.areaDescription.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(SearchAddress());
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
                                  labelText: 'Start Price',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a price for your service request';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Please enter a valid price';
                                  }
                                  if (int.tryParse(value)! > kMaximumPrice) {
                                    return 'Maximum price is 300 NIS';
                                  }
                                  return null;
                                },
                                onSaved: (String? value) {
                                  controller.startPrice = int.parse(value!);
                                },
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              TextFormField(
                                style: kTextStyleTextFiled,
                                decoration: kTextFieldInputDecoration.copyWith(
                                  prefixIcon: const Icon(
                                    Icons.attach_money,
                                    color: kColorBlueText,
                                  ),
                                  labelText: 'End Price',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a price for your service request';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Please enter a valid price';
                                  }
                                  if (int.tryParse(value)! > kMaximumPrice) {
                                    return 'Maximum price is 300 NIS';
                                  }
                                  return null;
                                },
                                onSaved: (String? value) {
                                  controller.endPrice = int.parse(value!);
                                },
                              ),
                              const SizedBox(height: 16.0),
                              RoundIconButton(
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
                                  if (!controller.formKey.currentState!
                                      .validate()) {
                                    return;
                                  }
                                  controller.formKey.currentState!.save();
                                  controller.newService = OfferServiceModel(
                                    title: controller.title!,
                                    provider: UserController
                                        .instance.user.value.email,
                                    category: convertStringToCategory(
                                        controller.category),
                                    area: controller.area!,
                                    areaDescription:
                                        controller.areaDescription.value,
                                    description: controller.description!,
                                    price: {
                                      'start': controller.startPrice!,
                                      'end': controller.endPrice!,
                                    },
                                  );
                                  ServiceRepository.instance.createOfferService(
                                      controller.newService);
                                },
                              ),
                            ],
                          ),
                        )
                      : StreamBuilder(
                          stream: ServiceRepository.instance
                              .getAllUserOfferServices(
                                  UserController.instance.user.value.email),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }

                            var serviceDocs = snapshot.data!.docs;
                            controller.serviceList = [];
                            for (var doc in serviceDocs) {
                              controller.serviceList.add(
                                  OfferServiceModel.fromSnapshot(doc
                                      as DocumentSnapshot<
                                          Map<String, dynamic>>));
                            }
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: SizedBox(
                                height: 500,
                                child: ListView.builder(
                                  itemCount: controller.serviceList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    OfferServiceModel service =
                                        controller.serviceList[index];
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 4,
                                      child: ListTile(
                                        title: Text(service.title),
                                        subtitle: Text(service.description),
                                        leading: Icon(
                                          categoriesIcon[service.category],
                                          size: 30,
                                        ),
                                        trailing: Icon(Icons.arrow_forward),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return OfferServiceDialog(
                                                service: service,
                                                isConsumer: false,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
