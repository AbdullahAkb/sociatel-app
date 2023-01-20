import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/db/firestore_db.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<UserModel> userData() async {
    String? uid;
    if (currentUser != null) {
      uid = currentUser!.uid;
    }

    DocumentSnapshot ref = await FirestoreDb.userReference.doc(uid).get();
    UserModel data = UserModel.fromjson(ref as Map<String, dynamic>);
    update();

    return data;
  }

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
  }
}
