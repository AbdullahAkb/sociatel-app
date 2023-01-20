import 'package:exd_social_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';

import 'chat.dart';
import 'util.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        title: Text(
          "Users",
          style: TextStyle(
              fontFamily: "Josefin Sans",
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
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
      body: StreamBuilder<List<types.User>>(
        stream: FirebaseChatCore.instance.users(),
        initialData: const [],
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: const Text('No users'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];

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
                      _handlePressed(user, context);
                    },
                    leading: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      height: height * 0.057,
                      width: width * 0.125,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: Image.network(
                          user.metadata!["imageUrl"].toString(),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    title: Text(
                      user.firstName.toString(),
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
                  print("Inwoke");
                  _handlePressed(user, context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      _buildAvatar(user),
                      Text(getUserName(user)),
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

  Widget _buildAvatar(types.User user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = getUserName(user);

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
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

  void _handlePressed(types.User otherUser, BuildContext context) async {
    final navigator = Navigator.of(context);
    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    navigator.pop();
    await navigator.push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
        ),
      ),
    );
  }
}
