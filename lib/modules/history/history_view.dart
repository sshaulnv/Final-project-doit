import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/constants/categories.dart';
import '../../shared/constants/constants.dart';
import '../../shared/constants/service_status.dart';
import '../../shared/models/service_model.dart';
import '../../shared/repositories/service_repository.dart';
import '../../shared/widgets/filters_dialog.dart';
import '../../shared/widgets/round_icon_button.dart';
import '../../shared/widgets/service_dialog.dart';
import 'package:get/get.dart';

import 'history_controller.dart';

class HistoryScreen extends StatefulWidget {
  // List serviceHistory;
  // HistoryScreen({required this.serviceHistory});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteBackgroundColor,
      // bottomNavigationBar: BottomNavigator(screenIndex: 2),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'History',
                    style: kTextStyleHeader.copyWith(fontSize: 40),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundIconButton(
                      color: Colors.white,
                      icon: const Icon(
                        Icons.filter_alt,
                        color: kRoundButtonBackgroundColor,
                      ),
                      text: const Text(
                        'Categories',
                        style: TextStyle(
                          color: kColorBlueText,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CategoryFilterDialog(
                              options: Categories.values.toList(),
                              controller: controller,
                            );
                          },
                        ).then((value) => controller.filteredServiceList());
                      },
                    ),
                    SizedBox(width: 20),
                    Obx(
                      () => RoundIconButton(
                        color: controller.filters['Provide'].value
                            ? Colors.white
                            : kRoundButtonBackgroundColor,
                        icon: Icon(
                          Icons.filter_alt,
                          color: controller.filters['Provide'].value
                              ? kRoundButtonBackgroundColor
                              : Colors.white,
                        ),
                        text: Text(
                          'Provide',
                          style: TextStyle(
                            color: controller.filters['Provide'].value
                                ? kRoundButtonBackgroundColor
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          controller.filters['Provide'].value =
                              controller.filters['Provide'].value
                                  ? false
                                  : true;
                          controller.filteredServiceList();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Obx(
                      () => RoundIconButton(
                        color: controller.filters['Consume'].value
                            ? Colors.white
                            : kRoundButtonBackgroundColor,
                        icon: Icon(
                          Icons.filter_alt,
                          color: controller.filters['Consume'].value
                              ? kRoundButtonBackgroundColor
                              : Colors.white,
                        ),
                        text: Text(
                          'Consume',
                          style: TextStyle(
                            color: controller.filters['Consume'].value
                                ? kRoundButtonBackgroundColor
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          controller.filters['Consume'].value =
                              controller.filters['Consume'].value
                                  ? false
                                  : true;
                          controller.filteredServiceList();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: ServiceRepository.instance.getAllUserServices(
                      UserController.instance.user.value.email),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    var serviceDocs = snapshot.data!.docs;
                    controller.serviceList = [];
                    for (var doc in serviceDocs) {
                      controller.serviceList.add(ServiceModel.fromSnapshot(
                          doc as DocumentSnapshot<Map<String, dynamic>>));
                    }
                    controller.serviceList = controller.serviceList
                        .where((service) =>
                            service.status == ServiceStatus.COMPLETED)
                        .toList();
                    controller.filteredList = controller.serviceList.obs;

                    return Obx(
                      () => Expanded(
                        flex: 2,
                        child: ListView.builder(
                          itemCount: controller.filteredList.length,
                          itemBuilder: (BuildContext context, int index) {
                            ServiceModel service =
                                controller.filteredList[index];
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
                                      return ServiceDialog(
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
            ],
          ),
        ),
      ),
    );
  }
}
