import 'package:doit_app/modules/chat/chat_view.dart';
import 'package:doit_app/shared/repositories/chat_repository.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService extends GetxController {
  static ChatService get instance => Get.find();

  Future<void> startChat(String otherEmail) async {
    types.User otherUser =
        await ChatRepository.instance.getChatUser(otherEmail);
    final room = await FirebaseChatCore.instance.createRoom(otherUser);
    Get.to(() => ChatScreen(room: room));
  }
}
