import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit_app/app/utils.dart';
import 'package:flutter/material.dart';

import '../constants/categories.dart';
import '../constants/service_status.dart';

class ServiceModel {
  final String? id;
  final String? provider; // email
  final String consumer; // email
  final String title;
  final Categories category;
  final DateTime date;
  final TimeOfDay hour;
  final GeoPoint sourceAddress;
  final String sourceAddressDescription;
  final GeoPoint destAddress;
  final String destAddressDescription;
  final String description;
  final int price;
  final ServiceStatus status;

  const ServiceModel({
    this.id,
    this.provider,
    required this.consumer,
    required this.title,
    required this.category,
    required this.date,
    required this.hour,
    required this.sourceAddress,
    required this.sourceAddressDescription,
    required this.destAddress,
    required this.destAddressDescription,
    required this.description,
    required this.price,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "provider": provider,
      "consumer": consumer,
      "title": title,
      "category": category.toString().split('.')[1],
      "date": Timestamp.fromDate(date),
      "hour": timeOfDayToTimestamp(hour),
      "sourceAddress": sourceAddress,
      "sourceAddressDescription": sourceAddressDescription,
      "destAddress": destAddress,
      "destAddressDescription": destAddressDescription,
      "description": description,
      "price": price,
      "status": status.toString().split('.')[1],
    };
  }

  factory ServiceModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ServiceModel(
      id: document.id,
      provider: data["provider"],
      consumer: data["consumer"],
      title: data["title"],
      category: convertStringToCategory(data["category"]),
      date: data["date"].toDate(),
      hour: timestampToTimeOfDay(data["hour"]),
      sourceAddress: data["sourceAddress"],
      sourceAddressDescription: data["sourceAddressDescription"],
      destAddress: data["destAddress"],
      destAddressDescription: data["destAddressDescription"],
      description: data["description"],
      price: data["price"],
      status: convertStringToServiceStatus(data["status"]),
    );
  }
}
