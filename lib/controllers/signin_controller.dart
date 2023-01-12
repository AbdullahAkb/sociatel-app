import 'package:exd_social_app/auth/firebase_auth.dart';
import 'package:exd_social_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SigninController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxString hintEmail = "abdullahakb111@gmail.com".obs;
  RxString hintPass = "********".obs;
  RxBool secure = true.obs;
  bool status = false;

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

  onPressed() async {
    status = await Auth.signinUser(
        email: emailController.text, password: passwordController.text);

        

    status
        ? Get.to(() => HomeScreen(), transition: Transition.rightToLeft)
        : printError(info: "Error", logFunction: () {});
    update();
  }

  isSecure() {
    secure.value = !secure.value;
  }

 
}
