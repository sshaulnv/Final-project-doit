import 'package:doit_app/modules/search_service/recommendations/recommendations_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/constants/categories.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/models/service_model.dart';
import '../../../shared/widgets/service_dialog.dart';

class RecommendationsScreen extends StatefulWidget {
  // List serviceHistory;
  // HistoryScreen({required this.serviceHistory});
  List<ServiceModel> recommendedServices;
  RecommendationsScreen({required this.recommendedServices});
  @override
  RecommendationsScreenState createState() => RecommendationsScreenState();
}

class RecommendationsScreenState extends State<RecommendationsScreen> {
  final RecommendationsController controller =
      Get.put(RecommendationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x88171717),
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
                    style: kTextStyleWhiteHeader.copyWith(fontSize: 30),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: widget.recommendedServices.length,
                  itemBuilder: (BuildContext context, int index) {
                    ServiceModel service = widget.recommendedServices[index];
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
            ],
          ),
        ),
      ),
    );
  }
}
