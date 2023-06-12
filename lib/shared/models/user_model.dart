import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? uid;
  String username;
  String email;
  String password;
  List<dynamic> provideServices;
  List<dynamic> consumeServices;
  Map<String, dynamic> categoriesPreferences;
  Map<String, dynamic> preferredHours;
  Map<String, dynamic> preferredPrice;
  int preferredDistance;

  UserModel({
    this.id,
    this.uid,
    required this.username,
    required this.email,
    required this.password,
    this.provideServices = const [],
    this.consumeServices = const [],
    this.categoriesPreferences = const {},
    this.preferredHours = const {},
    this.preferredPrice = const {},
    this.preferredDistance = 20,
  });

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "email": email,
      "password": password,
      "provideServices": provideServices,
      "consumeServices": consumeServices,
      "categoriesPreferences": categoriesPreferences,
      "preferredHours": preferredHours,
      "preferredPrice": preferredPrice,
      "preferredDistance": preferredDistance,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      uid: data["uid"],
      username: data["username"],
      email: data["email"],
      password: data["password"],
      provideServices: data["provideServices"],
      consumeServices: data["consumeServices"],
      categoriesPreferences: data["categoriesPreferences"],
      preferredHours: data["preferredHours"],
      preferredPrice: data["preferredPrice"],
      preferredDistance: data["preferredDistance"],
    );
  }

  UserModel clone() => UserModel(
        id: id,
        uid: uid,
        username: username,
        email: email,
        password: password,
        provideServices: provideServices,
        consumeServices: consumeServices,
        categoriesPreferences: categoriesPreferences,
        preferredHours: preferredHours,
        preferredPrice: preferredPrice,
        preferredDistance: preferredDistance,
      );
}
