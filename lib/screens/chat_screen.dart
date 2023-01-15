// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/db/firestore_db.dart';
import 'package:exd_social_app/models/chat_model.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.chatUser}) : super(key: key);

  final UserModel chatUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController chatController = TextEditingController();

  sendMessage() async {
    DocumentSnapshot userData =
        await FirestoreDb.userReference.doc(FirestoreDb.currentUser!.uid).get();

    UserModel data = UserModel.fromDocumentSnapshot(userData);

    CollectionReference msg = FirestoreDb.messagesreference;

    ChatModel chatData = ChatModel(
        chatText: chatController.text,
        dateTime: DateFormat.Hms().format(DateTime.now()),
        imageUrl: " ",
        status: 1,
        senderUser: ChatUser(
            email: data.email,
            uid: data.uid,
            name: data.name,
            userImageUrl: data.profileImage),
        receiverUser: ChatUser(
            email: widget.chatUser.email,
            uid: widget.chatUser.uid,
            name: widget.chatUser.name,
            userImageUrl: widget.chatUser.profileImage));

    await msg.add(chatData.toJson());

    chatController.clear();
    receiveMessgae();
  }

  Stream<List<ChatModel>> receiveMessgae() async* {
    CollectionReference msg = FirestoreDb.messagesreference;
    List<ChatModel> chatList = [];

    QuerySnapshot snapshot = await msg.get();
    List<QueryDocumentSnapshot> chatsData = snapshot.docs;

    for (var i = 0; i < chatsData.length; i++) {
      ChatModel chats = ChatModel.fromDocumentSnapshot(snapshot: chatsData[i]);

      chatList.add(chats);
    }
    yield chatList;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 237, 237),
      appBar: AppBar(
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.phone_fill,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.videocam_fill,
                  color: Colors.black,
                  size: 30,
                ))
          ],
          title: Row(
            children: [
              SizedBox(
                height: height * 0.057,
                width: width * 0.125,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: Image.network(
                    widget.chatUser.profileImage,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.05,
              ),
              Text(
                widget.chatUser.name,
                style: TextStyle(
                    fontFamily: "Josefin Sans",
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white),
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                height: height * 0.795,
                padding: EdgeInsets.only(bottom: height * 0.01),
                color: Color.fromARGB(255, 237, 237, 237),
                child: StreamBuilder(
                  stream: receiveMessgae(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CupertinoActivityIndicator(
                          color: Color.fromARGB(255, 248, 101, 148),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        reverse: true,
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          ChatModel messageDataModel = snapshot.data![index];
                          ChatUser dataModelOfReciever =
                              messageDataModel.receiverUser;
                          ChatUser dataModelOfSender =
                              messageDataModel.senderUser;
                          return messageDataModel.status == 1 &&
                                  FirestoreDb.currentUser!.uid ==
                                      messageDataModel.senderUser.uid
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: width * 0.03),
                                          alignment: Alignment.center,
                                          height: height * 0.04,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                    255, 248, 101, 148)
                                                .withOpacity(0.7),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                          ),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              messageDataModel.chatText,
                                              style: TextStyle(
                                                  fontFamily: "Josefin Sans",
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.004,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          messageDataModel.dateTime
                                              .substring(1, 5),
                                          style: TextStyle(
                                              fontFamily: "Josefin Sans"),
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                        SizedBox(
                                          height: height * 0.037,
                                          width: width * 0.1,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            child: Image.network(
                                              messageDataModel
                                                  .senderUser.userImageUrl,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.008,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: width * 0.01,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: width * 0.03),
                                          alignment: Alignment.centerLeft,
                                          height: height * 0.04,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 202, 166),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                          ),
                                          child: Container(
                                            child: Text(
                                              softWrap: true,
                                              messageDataModel.chatText,
                                              style: TextStyle(
                                                  fontFamily: "Josefin Sans",
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.004,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        Text(
                                          messageDataModel.dateTime
                                              .substring(1, 5),
                                          style: TextStyle(
                                              fontFamily: "Josefin Sans"),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.02,
                ),
                Container(
                  width: width * 0.8,
                  child: TextFormField(
                    controller: chatController,
                    cursorColor: Color.fromARGB(255, 248, 101, 148),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 255, 202, 166),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 248, 101, 148),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      hintText: "Write Something!",
                      hintStyle: TextStyle(
                          fontFamily: "Josefin Sans", color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(
                      Icons.send_rounded,
                      color: Color.fromARGB(255, 248, 101, 148),
                    )),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
          ],
        ),
      ),
    );
  }
}







//keyboard

  