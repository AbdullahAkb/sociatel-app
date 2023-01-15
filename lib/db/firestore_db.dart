import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDb {
  static CollectionReference userReference =
      FirebaseFirestore.instance.collection("user");
  static CollectionReference postreference =
      FirebaseFirestore.instance.collection("post");
  static CollectionReference commentreference =
      FirebaseFirestore.instance.collection("comment");
  static CollectionReference messagesreference =
      FirebaseFirestore.instance.collection("messages");
  static CollectionReference messagereference =
      FirebaseFirestore.instance.collection("message");

  static User? currentUser = FirebaseAuth.instance.currentUser;
}
