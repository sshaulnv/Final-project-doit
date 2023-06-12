import 'package:doit_app/modules/chat/chat_view.dart';
import 'package:doit_app/shared/controllers/user_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../../app/theme.dart';
import '../../shared/constants/constants.dart';
import '../../shared/repositories/storage_repository/storage_repository.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteBackgroundColor,
      // bottomNavigationBar: BottomNavigator(screenIndex: 3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Chat Rooms',
                    style: kTextStyleHeader.copyWith(fontSize: 40),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder<List<types.Room>>(
                future: FirebaseChatCore.instance.rooms().first,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While the future is loading, show a loading spinner
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // If there is no data, show a message
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                        bottom: 200,
                      ),
                      child: const Text('No rooms'),
                    );
                  }
                  List<types.Room> rooms = [];
                  for (types.Room room in snapshot.data!) {
                    for (types.User user in room.users) {
                      if (user.metadata!["email"] ==
                          UserController.instance.user.value.email) {
                        rooms.add(room);
                        break;
                      }
                    }
                  }

                  return Expanded(
                    flex: 2,
                    child: ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (BuildContext context, int index) {
                        types.Room room = rooms[index];
                        return FutureBuilder<Widget>(
                          future: _buildAvatar(room),
                          builder: (context, snapshot) {
                            Widget? roomAvatar = CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 40,
                            );
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              roomAvatar = snapshot.data;
                            }
                            final otherUser = room.users.firstWhere(
                              (u) =>
                                  u.id !=
                                  UserController.instance.user.value.uid,
                            );
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 4,
                              child: ListTile(
                                contentPadding: EdgeInsets.all(8),
                                title: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text(
                                    otherUser.firstName.toString(),
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: RatingBar.builder(
                                  initialRating: double.tryParse(otherUser
                                      .metadata!["rating"]
                                      .toString())!,
                                  ignoreGestures: true,
                                  itemSize: 20,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 1.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                                leading: roomAvatar!,
                                trailing: const Padding(
                                  padding: EdgeInsets.only(right: 15.0),
                                  child: Icon(
                                    Icons.chat,
                                    size: 35,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ChatScreen(room: room);
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Widget> _buildAvatar(types.Room room) async {
    var color = Colors.transparent;
    String? url;
    bool hasImage = false;
    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != UserController.instance.user.value.uid,
        );
        print(otherUser.id);
        String photoPath = '/profile_photos/${otherUser.id}';
        final ref = StorageRepository.instance.storage.ref().child(photoPath);

        try {
          url = await ref.getDownloadURL();
          if (url != null) {
            hasImage = true;
          }
          // Use the URL to display the photo
        } catch (error) {
          if (error == 'storage/object-not-found') {
            print('Photo not found');
          } else {
            print('Error getting photo URL: $error');
          }
        }

        color = Colors.lightBlueAccent;
      } catch (e) {
        // Do nothing if other user is not found.
      }
    }

    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(url!) : null,
        radius: 30,
        child: !hasImage
            ? Text(
                name.isEmpty ? 'room' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }
}
