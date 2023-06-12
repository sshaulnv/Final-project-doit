import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit_app/modules/search_service/recommendations/recommendations_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/services/recommendation_service.dart';
import '../../../app/theme.dart';
import '../../../shared/constants/categories.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/controllers/user_controller.dart';
import '../../../shared/models/service_model.dart';
import '../../../shared/repositories/service_repository.dart';
import '../../../shared/widgets/service_dialog.dart';

class RecommendationsScreen extends StatefulWidget {
  // List serviceHistory;
  // HistoryScreen({required this.serviceHistory});
  // List<ServiceModel> recommendedServices;
  // RecommendationsScreen({required this.recommendedServices});
  @override
  RecommendationsScreenState createState() => RecommendationsScreenState();
}

class RecommendationsScreenState extends State<RecommendationsScreen> {
  final RecommendationsController controller =
      Get.put(RecommendationsController());

  @override
  void initState() {
    // TODO: implement initState
    controller.filteredList = [].obs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteBackgroundColor,
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
                    'Recommendations',
                    style: kTextStyleHeader.copyWith(fontSize: 30),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: ServiceRepository.instance.getAllServices(),
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
                    RecommendationService.instance
                        .recommend(controller.serviceList,
                            UserController.instance.user.value)
                        .then((recommendedServices) => {
                              controller.filteredList.value =
                                  recommendedServices.obs
                            });
                    return Obx(() => controller.filteredList != [].obs
                        ? Expanded(
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
                          )
                        : Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          )));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
