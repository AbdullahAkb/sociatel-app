import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/db/firestore_db.dart';
import 'package:exd_social_app/models/comment_model.dart';
import 'package:exd_social_app/models/post_model.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        userImage: widget.userDetails.profileImage,
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
      appBar: AppBar(
        elevation: 3,
        shadowColor: Color.fromARGB(255, 248, 101, 148),
        title: const Text('Comments'),
        actions: [
          IconButton(
              onPressed: () async {
                await addCommentToFirestore();
                Get.back();
              },
              icon: Icon(CupertinoIcons.paperplane,
                  color: Color.fromARGB(255, 36, 55, 72)))
        ],
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          height: height * 0.4,
          width: width,
          child: ClipRRect(
            child: Image.network(
              widget.userDetails.profileImage,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Text(widget.userDetails.name),
        Text(widget.userDetails.email),
        TextFormField(
          controller: commentController,
          decoration: InputDecoration(),
        ),
      ]),
    );
  }
}
