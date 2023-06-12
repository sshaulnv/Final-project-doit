import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatRepository extends GetxController {
  static ChatRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  types.User chatUserFromSnapshot(var document) {
    final data = document.data()!;
    return types.User(
      createdAt: data["createdAt"].millisecondsSinceEpoch,
      firstName: data["firstName"],
      id: document.id,
      imageUrl: data["imageUrl"],
      lastName: data["lastName"],
      lastSeen: data["lastSeen"].millisecondsSinceEpoch,
      metadata: data["metadata"],
      role: data["role"],
      updatedAt: data["updatedAt"].millisecondsSinceEpoch,
    );
  }

  Future<types.User> getChatUser(String email) async {
    CollectionReference collectionRef = _db.collection('users');
    QuerySnapshot querySnapshot = await collectionRef.get();
    List<types.User> chatUsers =
        querySnapshot.docs.map((doc) => chatUserFromSnapshot(doc)).toList();
    types.User user =
        chatUsers.firstWhere((obj) => obj.metadata!["email"] == email);
    return user;
  }
}
