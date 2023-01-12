import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDb {
  static CollectionReference userReference =
      FirebaseFirestore.instance.collection("users");
  static CollectionReference postreference =
      FirebaseFirestore.instance.collection("post");
  static CollectionReference commentreference =
      FirebaseFirestore.instance.collection("comment");

  static User? currentUser = FirebaseAuth.instance.currentUser;
}
