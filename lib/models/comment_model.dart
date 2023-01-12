import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CommentModel {
  CommentModel({
    required this.id,
    required this.commentText,
    required this.uid,
    required this.userName,
    required this.userImage,
    required this.postId,
    required this.dateTime,
  });

  CommentModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    id = documentSnapshot.id;
    uid = documentSnapshot['uid'] ?? " ";
    commentText = documentSnapshot["commentText"] ?? " ";
    userName = documentSnapshot["userName"] ?? " ";
    userImage = documentSnapshot["userImage"] ?? " ";
    postId = documentSnapshot["postId"] ?? " ";
    dateTime = documentSnapshot["dateTime"] ??
        DateFormat().format(DateTime.now()).toString();
  }

  // for post creation
  CommentModel.withoutId({
    required this.uid,
    required this.commentText,
    required this.userImage,
    required this.userName,
    required this.dateTime,
    required this.postId,
  });

  late final String commentText;
  late final String dateTime;
  late final String id;
  late final String postId;
  late final String uid;
  late final String userImage;
  late final String userName;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['commentText'] = commentText;
    data['userName'] = userName;
    data['userImage'] = userImage;
    data['dateTime'] = dateTime;
    data['postId'] = postId;
    return data;
  }
}
