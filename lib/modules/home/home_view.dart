import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit_app/modules/history/history_view.dart';
import 'package:doit_app/modules/home/home_controller.dart';
import 'package:doit_app/modules/profile/profile_view.dart';
import 'package:doit_app/shared/constants/categories.dart';
import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:doit_app/shared/repositories/service_repository.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doit_app/shared/constants/constants.dart';
import 'package:get/get.dart';
import '../../app/services/recommendation_service.dart';
import '../../shared/constants/service_status.dart';
import '../../shared/models/service_model.dart';
import '../../shared/widgets/service_dialog.dart';
import '../add_service/add_service_view.dart';
import '../search_service/map/map_view.dart';
import '../search_service/recommendations/recommendations_view.dart';

class HomeScreen extends StatelessWidget {
  final controller = Get.put(HomeController());

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RoundIconButton(
                color: kColorRoundButton,
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                text: const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  Get.to(() => ProfileScreen());
                },
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
                        Icons.home,
                        color: kColorBlueText,
                      ),
                      text: const Text(
                        'Home',
                        style: TextStyle(
                          color: kColorBlueText,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(width: 20),
                    RoundIconButton(
                      color: kColorRoundButton,
                      icon: const Icon(
                        Icons.list_alt,
                        color: Colors.white,
                      ),
                      text: const Text(
                        'History',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => HistoryScreen());
                      },
                    ),
                    SizedBox(width: 20),
                    RoundIconButton(
                      color: kColorRoundButton,
                      icon: const Icon(
                        Icons.work,
                        color: Colors.white,
                      ),
                      text: const Text(
                        'New Service',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => AddServiceScreen());
                      },
                    ),
                    const SizedBox(width: 20),
                    RoundIconButton(
                      color: kColorRoundButton,
                      icon: const Icon(
                        Icons.map_outlined,
                        color: Colors.white,
                      ),
                      text: const Text(
                        'Search Map',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => SearchMap());
                      },
                    ),
                    const SizedBox(width: 20),
                    RoundIconButton(
                      color: kColorRoundButton,
                      icon: const Icon(
                        Icons.person_pin_outlined,
                        color: Colors.white,
                      ),
                      text: const Text(
                        'Recommendations',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () async {
                        // TODO: filter services
                        List<ServiceModel> allServices =
                            await ServiceRepository.instance.getAllServices();
                        print(UserController.instance.user.value.username);
                        List<ServiceModel> recommendedServices =
                            await RecommendationService.instance.recommend(
                                allServices,
                                UserController.instance.user.value);

                        Get.to(
                          () => RecommendationsScreen(
                            recommendedServices: recommendedServices,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Services You Provide:',
                style: kTextStyleWhiteHeader.copyWith(
                    fontSize: 25,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: ServiceRepository.instance.provideServiceStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  }
                  var provideServiceDocs = snapshot.data!.docs;
                  var provideServiceList = [];
                  for (var doc in provideServiceDocs) {
                    provideServiceList.add(ServiceModel.fromSnapshot(
                        doc as DocumentSnapshot<Map<String, dynamic>>));
                  }
                  provideServiceList = provideServiceList
                      .where((service) =>
                          service.status != ServiceStatus.COMPLETED)
                      .toList();
                  return Expanded(
                    child: ListView.builder(
                      itemCount: provideServiceList.length,
                      itemBuilder: (BuildContext context, int index) {
                        ServiceModel service = provideServiceList[index];
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
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                'Services You Consume:',
                style: kTextStyleWhiteHeader.copyWith(
                    fontSize: 25,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: ServiceRepository.instance.consumeServiceStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  }
                  var consumeServiceDocs = snapshot.data!.docs;
                  var consumeServiceList = [];
                  for (var doc in consumeServiceDocs) {
                    consumeServiceList.add(ServiceModel.fromSnapshot(
                        doc as DocumentSnapshot<Map<String, dynamic>>));
                  }
                  consumeServiceList = consumeServiceList
                      .where((service) =>
                          service.status != ServiceStatus.COMPLETED)
                      .toList();
                  return Expanded(
                    child: ListView.builder(
                      itemCount: consumeServiceList.length,
                      itemBuilder: (BuildContext context, int index) {
                        ServiceModel service = consumeServiceList[index];
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
                                    isConsumer: true,
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
