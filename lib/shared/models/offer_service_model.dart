import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/categories.dart';

class OfferServiceModel {
  final String? id;
  final String provider; // email
  final String title;
  final Categories category;

  final GeoPoint area;
  final String areaDescription;
  final String description;
  final Map<String, dynamic> price;

  const OfferServiceModel({
    this.id,
    required this.provider,
    required this.title,
    required this.category,
    required this.area,
    required this.areaDescription,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      "provider": provider,
      "title": title,
      "category": category.toString().split('.')[1],
      "area": area,
      "areaDescription": areaDescription,
      "description": description,
      "price": price,
    };
  }

  factory OfferServiceModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return OfferServiceModel(
      id: document.id,
      provider: data["provider"],
      title: data["title"],
      category: convertStringToCategory(data["category"]),
      area: data["area"],
      areaDescription: data["areaDescription"],
      description: data["description"],
      price: data["price"],
    );
  }
}
