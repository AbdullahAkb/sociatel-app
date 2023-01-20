import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';

import 'chat.dart';
import 'login.dart';
import 'users.dart';
import 'util.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  bool _error = false;
  bool _initialized = false;
  User? _user;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        title: Text(
          "Chats",
          style: TextStyle(
              fontFamily: "Josefin Sans",
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.meeting_room_rounded,
              color: Colors.black,
            ),
            onPressed: _user == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const UsersPage(),
                      ),
                    );
                  },
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
          // onPressed: _user == null ? null : logout,
        ),
      ),
      body: _user == null
          ? Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not authenticated'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            )
          : StreamBuilder<List<types.Room>>(
              stream: FirebaseChatCore.instance.rooms(),
              initialData: const [],
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                      bottom: 200,
                    ),
                    child: const Text('No rooms'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final room = snapshot.data![index];

                    return Container(
                      alignment: Alignment.center,
                      height: height * 0.09,
                      margin: EdgeInsets.only(
                          left: width * 0.03,
                          right: width * 0.03,
                          top: height * 0.03),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 248, 101, 148),
                              Color.fromARGB(255, 255, 202, 166),
                            ],
                          )),
                      child: ListTile(
                          onTap: () async {
                            Get.to(ChatPage(room: room));
                            // _handlePressed(user, context);
                          },
                          leading: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                            height: height * 0.057,
                            width: width * 0.125,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              child: Image.network(
                                room.users[0].metadata!["imageUrl"].toString(),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          title: Text(
                            room.name.toString(),
                            style: TextStyle(
                                fontFamily: "Josefin Sans",
                                fontSize: 17,
                                color: Colors.black),
                          ),
                          subtitle: Text(
                            "hello!",
                            style: TextStyle(
                                fontFamily: "Josefin Sans",
                                fontSize: 14,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          trailing: InkWell(
                            child: Container(
                              height: height * 0.05,
                              width: width * 0.14,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 247, 247, 247),
                                  shape: BoxShape.circle),
                              child: Icon(
                                CupertinoIcons.phone_fill,
                                color: Color.fromARGB(255, 248, 101, 148),
                              ),
                            ),
                          )),
                    );

                    return GestureDetector(
                      onTap: () {
                        print("inwoke");
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              room: room,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            _buildAvatar(room),
                            Text(room.name ?? ''),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp(
          // options: DefaultFirebaseOptions.currentPlatform,
          );
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != _user!.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found.
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }
}
