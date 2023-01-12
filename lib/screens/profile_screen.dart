import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/controllers/image_picker_controller.dart';
import 'package:exd_social_app/db/firestore_db.dart';
import 'package:exd_social_app/models/post_model.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:exd_social_app/screens/comment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel details;
  const ProfileScreen({Key? key, required this.details}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<PostModelNew> postList = [];
  bool likeState = true;

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
      });
    } else {
      likeCountdecrement(id);
      setState(() {
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
        centerTitle: true,
        title: Text(widget.details.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.067,
              width: width * 0.14,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  child: InkWell(
                    onTap: () {},
                    child: Image.network(
                      widget.details.profileImage,
                      fit: BoxFit.cover,
                    ),
                  )),
            ),
            Text(widget.details.email),
            Text(widget.details.phone),
            StreamBuilder(
              stream: postOfUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CupertinoActivityIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
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
                                    " ${snapshot.data![index].likesCount.toString()} likes",
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
