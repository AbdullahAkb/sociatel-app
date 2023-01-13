import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/controllers/image_picker_controller.dart';
import 'package:exd_social_app/db/firestore_db.dart';
import 'package:exd_social_app/models/post_model.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:exd_social_app/screens/comment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.details}) : super(key: key);

  final UserModel details;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  bool likeState = true;
  int likes = 0;
  List<PostModelNew> postList = [];

  Stream<List<PostModelNew>> postOfUser() async* {
    QuerySnapshot postReference = await FirebaseFirestore.instance
        .collection("post")
        .where("uid", isEqualTo: currentUser!.uid)
        .get();

    for (var i = 0; i < postReference.docs.length; i++) {
      PostModelNew obj =
          PostModelNew.fromDocumentSnapshot(postReference.docs[i]);
      postList.add(obj);
    }

    yield postList;
  }

  likeCountIncrement(String id) async {
    await FirestoreDb.postreference
        .doc(id)
        .update({"likesCount": FieldValue.increment(1)});
  }

  likeCountdecrement(String id) async {
    await FirestoreDb.postreference
        .doc(id)
        .update({"likesCount": FieldValue.increment(-1)});
  }

  postLike(String id) {
    if (likeState == true) {
      likeCountIncrement(id);
      setState(() {
        likeState = !likeState;
        if (likes == 0) {
          likes = likes + 1;
        }
      });
    } else {
      likeCountdecrement(id);

      setState(() {
        if (likes != 0) {
          likes = likes - 1;
        }
        likeState = !likeState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(fontFamily: "Josefin Sans", color: Colors.black),
        ),
        elevation: 3,
        shadowColor: Color.fromARGB(255, 248, 101, 148),
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
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(CupertinoIcons.paperplane, color: Colors.black))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: height * 0.1),
                      padding: EdgeInsets.only(top: height * 0.05),
                      height: height * 0.17,
                      width: width * 0.9,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 212, 209, 209),
                                offset: Offset(0, 1),
                                blurRadius: 4,
                                spreadRadius: 2)
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name:",
                                    style: TextStyle(
                                        fontFamily: "Josefin Sans",
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    "Email:",
                                    style: const TextStyle(
                                        fontFamily: "Josefin Sans",
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  const Text(
                                    "Phone #:",
                                    style: TextStyle(
                                        fontFamily: "Josefin Sans",
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.details.name,
                                    style: TextStyle(
                                      fontFamily: "Josefin Sans",
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 248, 101, 148),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    widget.details.email,
                                    style: TextStyle(
                                      fontFamily: "Josefin Sans",
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 248, 101, 148),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    widget.details.phone,
                                    style: TextStyle(
                                      fontFamily: "Josefin Sans",
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 248, 101, 148),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly
                  children: [
                    SizedBox(
                      width: width * 0.23,
                    ),
                    Container(
                      height: height * 0.135,
                      width: width * 0.3,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 251, 194, 212),
                                offset: Offset(0, 1),
                                blurRadius: 4,
                                spreadRadius: 2)
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: Image.network(
                          widget.details.profileImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: width * 0.8, top: height * 0.09),
                  child: IconButton(
                      splashColor: Colors.white,
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.pencil_outline,
                        color: Color.fromARGB(255, 248, 101, 148),
                      )),
                )
              ],
            ),
            SizedBox(
              height: height * 0.04,
            ),
            StreamBuilder<List<PostModelNew>>(
              stream: postOfUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CupertinoActivityIndicator());
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      PostModelNew details = snapshot.data![index];
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(
                            //   height: height * 0.01,
                            // ),

                            Container(
                              margin: EdgeInsets.only(
                                  left: width * 0.03, right: width * 0.03),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: height * 0.065,
                                    width: width * 0.14,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      child: Image.network(
                                        details.userImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: height * 0.013,
                                      ),
                                      Text(
                                        widget.details.name,
                                        style: TextStyle(
                                            fontFamily: "Josefin Sans",
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Text(
                                        details.dateTime,
                                        style: TextStyle(
                                            fontFamily: "Josefin Sans",
                                            color: Color.fromARGB(
                                                255, 248, 101, 148)),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.more_horiz_rounded)),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        CupertinoIcons.clear,
                                        size: 20,
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: width * 0.03, right: width * 0.03),
                              child: Text(
                                details.postText,
                                style: TextStyle(
                                    fontFamily: "Josefin Sans", fontSize: 15),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Container(
                              height: height * 0.4,
                              width: width,
                              child: Image.network(
                                details.postImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.015,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: width * 0.03, right: width * 0.03),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    " ${likes.toString()} likes",
                                    style:
                                        TextStyle(fontFamily: "Josefin Sans"),
                                  ),
                                  Text(
                                    "129comments",
                                    style:
                                        TextStyle(fontFamily: "Josefin Sans"),
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      postLike(details.id);
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.hand_thumbsup,
                                            color: Colors.pinkAccent,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: height * 0.008),
                                            child: Text(
                                              "Like",
                                              style: TextStyle(
                                                  fontFamily: "Josefin Sans",
                                                  color: Color.fromARGB(
                                                      255, 132, 132, 132)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(CommentScreen(
                                        details: details,
                                        userDetails: widget.details,
                                      ));
                                    },
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: height * 0.008),
                                            child: Icon(
                                              Icons.messenger_outline,
                                              color: Colors.greenAccent,
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: height * 0.008),
                                            child: Text(
                                              "Comment",
                                              style: TextStyle(
                                                  fontFamily: "Josefin Sans",
                                                  color: Color.fromARGB(
                                                      255, 132, 132, 132)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.ios_share_rounded,
                                            color: Colors.blueAccent,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: height * 0.008,
                                            ),
                                            child: Text(
                                              "Share",
                                              style: TextStyle(
                                                  fontFamily: "Josefin Sans",
                                                  color: Color.fromARGB(
                                                      255, 132, 132, 132)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: height * 0.01,
                              height: height * 0.05,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
