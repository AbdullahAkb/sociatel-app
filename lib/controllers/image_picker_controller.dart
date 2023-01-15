// ignore_for_file: avoid_print, unused_local_variable

import 'dart:io';
import 'package:exd_social_app/auth/firebase_auth.dart';
import 'package:exd_social_app/models/post_model.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

class ImagePickerController extends GetxController {
  CroppedFile? croppedFile;
  CroppedFile? croppedPostImage;
  User? currentUser = FirebaseAuth.instance.currentUser;
  File? imageFile;
  //
  dynamic postImage;

  String? postImageUrl;
  List<PostModelNew> postList = [];
  TextEditingController postTextController = TextEditingController();
  CollectionReference postsReference =
      FirebaseFirestore.instance.collection("post");

  CroppedFile? profileCroppedFile;
  File? profile_imageFile;
  CollectionReference usersReference =
      FirebaseFirestore.instance.collection("user");

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    postOfUser();
    super.onInit();
  }

  imagePickerForProfile() async {
    final ImagePicker picker = ImagePicker();
// Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    croppedFile = await ImageCropper()
        .cropImage(sourcePath: image!.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    ]);

    if (croppedFile != null) {
      imageFile = File(croppedFile!.path);

      update();
    }
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();

    File filePath = File(imageFile!.path);
    try {
      print("Abdullah");
      firebase_storage.UploadTask? uploadFile;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("Images")
          .child("/$imageName");

      uploadFile = ref.putFile(filePath);

      Future.value(uploadFile).then((value) async {
        String url = await ref.getDownloadURL();
        print(url);
        User? user = FirebaseAuth.instance.currentUser;
        String uid;
        if (user != null) {
          uid = user.uid;
        }

        DocumentReference userRef = Auth.userReference.doc(user!.uid);
        userRef.update({"coverImage": url});
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  uploadImageToStorage() async {
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();

    File filePath = File(profile_imageFile!.path);
    try {
      print("Abdullah");
      firebase_storage.UploadTask? uploadFile;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("Profile_Images")
          .child("/$imageName");

      uploadFile = ref.putFile(filePath);

      Future.value(uploadFile).then((value) async {
        String url = await ref.getDownloadURL();
        print(url);
        User? user = FirebaseAuth.instance.currentUser;

        String uid;
        if (user != null) {
          uid = user.uid;
        }

        DocumentReference userRef = Auth.userReference.doc(user!.uid);
        userRef.set({"profileImage": url});
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  uploadCoverImageToStorage() async {
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();

    File filePath = File(imageFile!.path);
    try {
      print("Abdullah");
      firebase_storage.UploadTask? uploadFile;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("Images")
          .child("/$imageName");

      uploadFile = ref.putFile(filePath);

      Future.value(uploadFile).then((value) async {
        String url = await ref.getDownloadURL();
        print(url);
        User? user = FirebaseAuth.instance.currentUser;
        // ignore: unused_local_variable
        String uid;
        if (user != null) {
          uid = user.uid;
        }

        DocumentReference userRef = Auth.userReference.doc(user!.uid);
        userRef.update({"coverImage": url});
      });
    } catch (e) {}
  }

  profileImagePickerForProfile() async {
    final ImagePicker picker = ImagePicker();
// Pick an image
    final XFile? profileimage =
        await picker.pickImage(source: ImageSource.gallery);

    profileCroppedFile = await ImageCropper()
        .cropImage(sourcePath: profileimage!.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    ]);

    if (profileCroppedFile != null) {
      profile_imageFile = File(profileCroppedFile!.path);

      update();
    }
  }

  imagePickerForPostFromGallery() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
    croppedPostImage = await ImageCropper()
        .cropImage(sourcePath: image!.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    ]);
    if (croppedPostImage != null) {
      postImage = File(croppedPostImage!.path);
      update();
    }

    String postImageName = DateTime.now().millisecondsSinceEpoch.toString();
    File postfilePath = File(postImage!.path);
    try {
      print("Abdullah");
      firebase_storage.UploadTask? uploadFile;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("Post_Images")
          .child("/$postImageName");
      uploadFile = ref.putFile(postfilePath);
      Future.value(uploadFile).then((value) async {
        postImageUrl = await ref.getDownloadURL();

        print(postImageUrl);
      });
    } catch (e) {
      printError(info: "Error");
    }
  }

  imagePickerForPostFromCamera() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 20);
    croppedPostImage = await ImageCropper()
        .cropImage(sourcePath: image!.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    ]);
    if (croppedPostImage != null) {
      postImage = File(croppedPostImage!.path);
      update();
    }

    String postImageName = DateTime.now().millisecondsSinceEpoch.toString();
    File postfilePath = File(postImage!.path);
    try {
      print("Abdullah");
      firebase_storage.UploadTask? uploadFile;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("Post_Images")
          .child("/$postImageName");
      uploadFile = ref.putFile(postfilePath);
      Future.value(uploadFile).then((value) async {
        postImageUrl = await ref.getDownloadURL();

        print(postImageUrl);
      });
    } catch (e) {
      printError(info: "Error");
    }
  }

  postToFirestore() async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection("post");
    DocumentSnapshot userData =
        await usersReference.doc(currentUser!.uid).get();

    UserModel userdata = UserModel.fromDocumentSnapshot(userData);
    // var date = DateFormat.d().dateOnly.toString();
    PostModelNew data = PostModelNew.withoutId(
        likesCount: 0,
        uid: currentUser!.uid,
        postText: postTextController.text,
        userImage: userdata.profileImage,
        postImage: postImageUrl.toString(),
        dateTime: DateTime.now().toUtc().toString(),
        commentsCount: 0);

    await reference.add(data.toJson());
  }

  Future<List<PostModelNew>> postOfUser() async {
    QuerySnapshot postReference = await FirebaseFirestore.instance
        .collection("post")
        .where("uid", isEqualTo: currentUser!.uid)
        .get();

    for (var i = 0; i < postReference.docs.length; i++) {
      PostModelNew obj =
          PostModelNew.fromDocumentSnapshot(postReference.docs[i]);
      postList.add(obj);
    }
    update();
    return postList;
  }
}
