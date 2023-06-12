import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit_app/modules/home/home_controller.dart';
import 'package:doit_app/shared/constants/categories.dart';
import 'package:doit_app/shared/repositories/service_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doit_app/shared/constants/constants.dart';
import 'package:get/get.dart';
import '../../app/theme.dart';
import '../../shared/constants/service_status.dart';
import '../../shared/models/service_model.dart';
import '../../shared/widgets/service_dialog.dart';
import '../../shared/widgets/squere_icon_button.dart';
import '../add_service/add_service_view.dart';
import '../providers/providers_view.dart';
import '../search_service/map/map_view.dart';
import '../search_service/recommendations/recommendations_view.dart';
import '../suggest_service/suggest_service_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteBackgroundColor,
      // bottomNavigationBar: BottomNavigator(screenIndex: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(10),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquereIconButton(
                      icon: const Icon(
                        Icons.request_page,
                        color: Colors.white,
                        size: 40,
                      ),
                      text: const Text(
                        'Request Service',
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
                    SquereIconButton(
                      icon: const Icon(
                        Icons.work,
                        color: Colors.white,
                        size: 40,
                      ),
                      text: const Text(
                        'Suggest Service',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => SuggestServiceScreen());
                      },
                    ),
                    const SizedBox(width: 20),
                    SquereIconButton(
                      icon: const Icon(
                        Icons.map_outlined,
                        color: Colors.white,
                        size: 40,
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
                    SquereIconButton(
                      icon: const Icon(
                        Icons.recommend,
                        color: Colors.white,
                        size: 40,
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
                        Get.to(
                          () => RecommendationsScreen(),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    SquereIconButton(
                      icon: const Icon(
                        Icons.handshake,
                        color: Colors.white,
                        size: 40,
                      ),
                      text: const Text(
                        'Providers',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () async {
                        Get.to(
                          () => ProvidersScreen(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Services You Provide',
                  style: kTextStyleHeader.copyWith(fontSize: 30),
                ),
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
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Services You Consume',
                  style: kTextStyleHeader.copyWith(fontSize: 30),
                ),
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
