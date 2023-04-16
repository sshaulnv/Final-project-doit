import 'package:doit_app/shared/constants/categories.dart';
import 'package:doit_app/shared/constants/service_status.dart';
import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:doit_app/shared/repositories/service_repository.dart';
import 'package:doit_app/shared/widgets/round_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/constants.dart';
import '../models/service_model.dart';

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
                          color: kColorRoundButton,
                          icon: const Icon(
                            Icons.chat,
                            color: Colors.white,
                          ),
                          text: Text(
                            'Chat ${isConsumer ? 'With Provider' : 'With Consumer'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (isConsumer)
                        RoundIconButton(
                          color: kColorRoundButton,
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
                            ServiceRepository.instance.updateServiceStatus(
                                service.id!, ServiceStatus.COMPLETED);
                          },
                        ),
                      if (!isConsumer &&
                          service.status == ServiceStatus.PENDING)
                        RoundIconButton(
                          color: kColorRoundButton,
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
                                UserController.instance.user.value.email);
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
