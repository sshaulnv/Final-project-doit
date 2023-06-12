import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit_app/modules/providers/providers_controller.dart';
import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../shared/constants/categories.dart';
import '../../shared/constants/constants.dart';
import '../../shared/models/offer_service_model.dart';
import '../../shared/repositories/service_repository.dart';
import '../../shared/widgets/filters_dialog.dart';
import '../../shared/widgets/offer_service_dialog.dart';
import '../../shared/widgets/round_icon_button.dart';
import 'package:get/get.dart';

class ProvidersScreen extends StatefulWidget {
  // List serviceHistory;
  // HistoryScreen({required this.serviceHistory});

  @override
  _ProvidersScreenState createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  final ProvidersController controller = Get.put(ProvidersController());

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
                    'Providers',
                    style: kTextStyleHeader.copyWith(fontSize: 40),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(10),
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
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: ServiceRepository.instance.getAllOfferServices(
                      UserController.instance.user.value.email),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    var serviceDocs = snapshot.data!.docs;
                    controller.serviceList = [];
                    for (var doc in serviceDocs) {
                      controller.serviceList.add(OfferServiceModel.fromSnapshot(
                          doc as DocumentSnapshot<Map<String, dynamic>>));
                    }
                    // controller.serviceList = controller.serviceList
                    //     .where((service) =>
                    //         service.status == ServiceStatus.COMPLETED)
                    //     .toList();
                    controller.filteredList = controller.serviceList.obs;
                    return Obx(
                      () => Expanded(
                        flex: 2,
                        child: ListView.builder(
                          itemCount: controller.filteredList.length,
                          itemBuilder: (BuildContext context, int index) {
                            OfferServiceModel service =
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
                                      return OfferServiceDialog(
                                        service: service,
                                        isConsumer: true,
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
