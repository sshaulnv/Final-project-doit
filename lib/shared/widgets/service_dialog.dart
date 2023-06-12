import 'package:doit_app/app/services/chat_service.dart';
import 'package:doit_app/shared/constants/categories.dart';
import 'package:doit_app/shared/constants/service_status.dart';
import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:doit_app/shared/repositories/service_repository.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../models/service_model.dart';
import '../repositories/user_repository.dart';

class ServiceDialog extends StatelessWidget {
  final ServiceModel service;
  final bool isConsumer;
  const ServiceDialog({required this.service, required this.isConsumer});

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
                        'Consumer: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        service.consumer.toString(),
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
                        'Source: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          service.sourceAddressDescription,
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
                        'Destination: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          service.destAddressDescription,
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
                        'Date: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${service.date.day}/${service.date.month}/${service.date.year}',
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Text(
                        'Hour: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${service.hour.format(context)}',
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
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
                          '${service.price} NIS',
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
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${convertStatusToString(service.status).capitalizeFirst}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: service.status == ServiceStatus.PENDING
                            ? Colors.redAccent
                            : Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if (service.status != ServiceStatus.COMPLETED)
                        RoundIconButton(
                          icon: const Icon(
                            Icons.chat,
                            color: Colors.white,
                          ),
                          text: Text(
                            'Chat With ${isConsumer ? 'Provider' : 'Consumer'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: isConsumer
                              ? (service.provider != null
                                  ? () {
                                      ChatService.instance
                                          .startChat(service.provider!);
                                    }
                                  : null)
                              : (service.consumer != null
                                  ? () {
                                      ChatService.instance
                                          .startChat(service.consumer!);
                                    }
                                  : null),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (isConsumer)
                        RoundIconButton(
                          icon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          text: const Text(
                            'Mark As Completed',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            if (service.provider != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: Container(
                                      height: 100,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.blueGrey,
                                              spreadRadius: 1),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Please rate the provider",
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          RatingBar.builder(
                                            initialRating: 0,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              UserRepository.instance
                                                  .updateUserRating(
                                                      service.provider!, rating)
                                                  .then((value) {
                                                Get.back();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                                  .then((value) => ServiceRepository.instance
                                      .updateServiceStatus(
                                          service.id!, ServiceStatus.COMPLETED))
                                  .then((value) => Get.back());
                            } else {
                              ServiceRepository.instance.updateServiceStatus(
                                  service.id!, ServiceStatus.COMPLETED);
                              Get.back();
                            }
                          },
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (service.status == ServiceStatus.INPROCESS)
                        RoundIconButton(
                          color: Colors.redAccent,
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                          text: const Text(
                            'Reject Provider',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: service.provider != null
                              ? () {
                                  ServiceRepository.instance
                                      .updateServiceProvide(
                                          service.id!,
                                          ServiceStatus.PENDING,
                                          null,
                                          'Success',
                                          'This service is now free');
                                }
                              : null,
                        ),
                      if (!isConsumer &&
                          service.status == ServiceStatus.PENDING)
                        RoundIconButton(
                          icon: const Icon(
                            Icons.check_outlined,
                            color: Colors.white,
                          ),
                          text: const Text(
                            'Provide',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            ServiceRepository.instance.updateServiceProvide(
                                service.id!,
                                ServiceStatus.INPROCESS,
                                UserController.instance.user.value.email,
                                'Success',
                                'Do Your Best!');
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
