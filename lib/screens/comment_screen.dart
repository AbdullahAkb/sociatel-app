import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/db/firestore_db.dart';
import 'package:exd_social_app/models/comment_model.dart';
import 'package:exd_social_app/models/post_model.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen(
      {Key? key, required this.details, required this.userDetails})
      : super(key: key);

  final PostModelNew details;
  final UserModel userDetails;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();

  addCommentToFirestore() async {
    CommentModel data = CommentModel.withoutId(
        uid: FirestoreDb.currentUser!.uid,
        commentText: commentController.text,
        userImage: widget.userDetails.metaData.imageUrl,
        userName: widget.userDetails.name,
        dateTime: DateTime.now().toUtc().toString(),
        postId: widget.details.id);
    await FirestoreDb.commentreference.add(data.toJson());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // centerTitle: true,
        title: Text(
          "Comments",
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
      body: Stack(children: [
        Container(
          margin: EdgeInsets.only(bottom: height * 0.015),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListTile(
                leading: SizedBox(
                  height: height * 0.057,
                  width: width * 0.125,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: Image.network(
                      widget.userDetails.metaData.imageUrl,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                title: SizedBox(
                  height: height * 0.06,
                  child: TextFormField(
                    controller: commentController,
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
                trailing: IconButton(
                    onPressed: () {
                      addCommentToFirestore();
                    },
                    icon: Icon(
                      Icons.send_rounded,
                      color: Color.fromARGB(255, 248, 101, 148),
                    )),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
