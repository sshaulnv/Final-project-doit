import 'package:doit_app/app/services/chat_service.dart';
import 'package:doit_app/shared/constants/categories.dart';
import 'package:doit_app/shared/repositories/service_repository.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/offer_service_model.dart';

class OfferServiceDialog extends StatelessWidget {
  final OfferServiceModel service;
  final bool isConsumer;
  const OfferServiceDialog({required this.service, required this.isConsumer});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${service.title.capitalizeFirst}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${convertCategoryToString(service.category).capitalizeFirst}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Text(
                        'Provider: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        service.provider != null
                            ? service.provider.toString()
                            : 'No provider yet',
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Text(
                        'Area: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          service.areaDescription,
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Text(
                        'Price: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${service.price!['start']} - ${service.price!['end']} NIS',
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(service
                          .description), // your service details widget goes here
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      isConsumer
                          ? RoundIconButton(
                              icon: const Icon(
                                Icons.chat,
                                color: Colors.white,
                              ),
                              text: const Text(
                                'Chat With Provider',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {
                                ChatService.instance
                                    .startChat(service.provider!);
                              },
                            )
                          : RoundIconButton(
                              icon: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              text: const Text(
                                'Close Service',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () {
                                ServiceRepository.instance
                                    .deleteOfferService(service.id!);
                                Get.back();
                              },
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
