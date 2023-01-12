import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/auth/firebase_auth.dart';
import 'package:exd_social_app/screens/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SignupController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumbController = TextEditingController();

  String hintEmail = "abdullahakb111@gmail.com";
  String hintPass = "********";
  String hintName = "Abdullah";
  String hintPhone = "03018677420";
  RxBool secure = true.obs;
  bool status = false;
  File? imageFile;
  File? profile_imageFile;
  CroppedFile? croppedFile;
  CroppedFile? profileCroppedFile;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter Your Email";
    }
    if (!GetUtils.isEmail(value)) {
      return "Enter Valid Email";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter Your Password";
    }
    if (value.length < 8) {
      return "Enter Valid Password";
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter Your  Full Name";
    }

    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter Your Phone Number";
    }
    if (value.length < 11) {
      return "Enter Valid Phone Number";
    }
    return null;
  }

  onSignUp() async {
    status = await Auth.signupUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      phoneNumb: phoneNumbController.text,
    );

    status
        ? Get.to(() => PostScreen())
        : printError(info: "Error", logFunction: () {});
  }

  isSecure() {
    secure.value = !secure.value;
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
        userRef.update({"profileImage": url});
      });
    } catch (e) {}
  }
}
