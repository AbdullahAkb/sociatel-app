import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/db/firestore_db.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:exd_social_app/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UserChatsScreen extends StatefulWidget {
  const UserChatsScreen({Key? key}) : super(key: key);

  @override
  State<UserChatsScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<UserChatsScreen> {
  Stream<List<UserModel>> listOfUsers() async* {
    QuerySnapshot userReference = await FirebaseFirestore.instance
        .collection("user")
        .where("uid", isNotEqualTo: FirestoreDb.currentUser!.uid)
        .get();
    List<UserModel> userList = [];
    for (var i = 0; i < userReference.docs.length; i++) {
      UserModel obj = UserModel.fromDocumentSnapshot(userReference.docs[i]);
      userList.add(obj);
    }

    yield userList;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Chats",
          style: TextStyle(
              fontFamily: "Josefin Sans",
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.white),
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            )),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: listOfUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CupertinoActivityIndicator(
              color: Color.fromARGB(255, 248, 101, 148),
            ));
          } else if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  UserModel details = snapshot.data![index];
                  return Column(
                    children: [
                      ListTile(
                        
                          onTap: () {
                            Get.to(ChatScreen(chatUser: details),
                                transition: Transition.rightToLeftWithFade);
                          },
                          leading: SizedBox(
                            height: height * 0.057,
                            width: width * 0.125,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              child: Image.network(
                                details.profileImage,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          title: Text(
                            details.name,
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
                                color: Colors.grey),
                          ),
                          trailing: InkWell(
                            child: Container(
                              height: height * 0.05,
                              width: width * 0.14,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 226, 226, 226),
                                  shape: BoxShape.circle),
                              child: Icon(
                                CupertinoIcons.phone_fill,
                                color: Color.fromARGB(255, 248, 101, 148),
                              ),
                            ),
                          )),
                    ],
                  );
                });
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "Seem like You have No Friends !",
                    style: TextStyle(
                      fontFamily: "Josefin Sans",
                      fontSize: 13,
                      color: Color.fromARGB(255, 248, 101, 148),
                    ),
                  ),
                ),
                Divider(
                  color: Color.fromARGB(255, 248, 101, 148),
                  indent: width * 0.4,
                  endIndent: width * 0.4,
                )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
