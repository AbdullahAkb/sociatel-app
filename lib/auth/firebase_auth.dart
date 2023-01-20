import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class Auth {
  static CollectionReference userReference =
      FirebaseFirestore.instance.collection("user");
  static String uid = "";

  static User? userstate = FirebaseAuth.instance.currentUser;

  static userId() {
    if (userstate != null) {
      uid = userstate!.uid;
    }
  }

  static Future<bool> signinUser(
      {required String email, required String password}) async {
    bool status = false;
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      status = true;
      print(status);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      status = false;
    }
    return status;
  }

  static Future<bool> signupUser({
    required String email,
    required String password,
    required String name,
    required String phoneNumb,
    required String imageUrl,
  }) async {
    bool status = false;
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Map<String, dynamic> userProfileData = {
        "phone": phoneNumb,
        "email": email,
        "imageUrl": imageUrl,
      };
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
            firstName: name,
            id: credential.user!.uid,
            imageUrl: imageUrl,
            metadata: userProfileData),
      );

      // User? currentUser = credential.user;
      // if (currentUser != null) {
      //   DocumentReference currentUserReference =
      //       userReference.doc(currentUser.uid);

      //   Map<String, dynamic> userProfileData = {
      //     "phone": phoneNumb,
      //     "name": name,
      //     "email": email,
      //     "uid": currentUser.uid,
      //     "profileImage": ""
      //   };

      //   await currentUserReference.set(userProfileData);
      // }

      status = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return status;
  }

  static Future<bool> signOut() async {
    bool status = false;
    try {
      await FirebaseAuth.instance.signOut();
      status = true;
    } catch (e) {}

    return status;
  }
}
