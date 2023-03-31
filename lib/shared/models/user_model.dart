import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String username;
  String email;
  String password;
  List<String> provideServices;
  List<String> consumeServices;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.provideServices = const [],
    this.consumeServices = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
      "provideServices": provideServices,
      "consumeServices": consumeServices,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      username: data["username"],
      email: data["email"],
      password: data["password"],
      provideServices: data["provideServices"],
      consumeServices: data["consumeServices"],
    );
  }
}
