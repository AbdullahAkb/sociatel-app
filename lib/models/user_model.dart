import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String name;
  late String phone;
  late String email;
  late String profileImage;
  late String coverImage;
  late String uid;

  UserModel.fromjson(
    Map<String, dynamic> data,
  ) {
    name = data["name"] ?? "";
    phone = data["phone"] ?? "";
    profileImage = data["profileImage"] ?? "";
    // coverImage = data["coverImage"] ?? "";
    uid = data["uid"];
    email = data["email"] ?? "ABullah";
  }

  UserModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    name = documentSnapshot["name"] ?? ' ';
    phone = documentSnapshot["phone"] ?? ' ';
    profileImage = documentSnapshot["profileImage"] ?? "";
    // coverImage = documentSnapshot["coverImage"] ?? " ";
    uid = documentSnapshot["uid"];
    email = documentSnapshot["email"] ?? "ABullah";
  }

  Map<String, dynamic> tojson() {
    final _data = <String, dynamic>{};
    _data["name"] = name;
    _data["phone"] = phone;
    _data["uid"] = uid;
    _data["email"] = email;
    return _data;
  }

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.uid});
}
