import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.name,
    required this.metaData,
  });

  UserModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    name = documentSnapshot["firstName"] ?? ' ';
    metaData = MetaData.fromjson(documentSnapshot["metadata"]);
  }

  UserModel.fromjson(
    Map<String, dynamic> data,
  ) {
    name = data["firstName"] ?? " ";
    metaData = MetaData.fromjson(data["metadata"]);
  }

  late MetaData metaData;
  late String name;

  Map<String, dynamic> tojson() {
    final _data = <String, dynamic>{};
    _data["firstName"] = name;
    _data["metadata"] = metaData.toJson();
    return _data;
  }
}

class MetaData {
  MetaData({
    required this.email,
    required this.phone,
    required this.imageUrl,
  });

  MetaData.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    email = documentSnapshot["email"] ?? ' ';
    phone = documentSnapshot["phone"] ?? ' ';
    imageUrl = documentSnapshot["imageUrl"] ?? ' ';
  }

  MetaData.fromjson(
    Map<String, dynamic> data,
  ) {
    email = data["email"] ?? "";
    phone = data["phone"] ?? "";
    imageUrl = data["imageUrl"] ?? " ";
  }

  late String email;
  late String imageUrl;
  late String phone;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data["email"] = email;
    _data["phone"] = phone;
    _data["imageUrl"] = imageUrl;
    return _data;
  }
}
