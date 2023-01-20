// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/auth/firebase_auth.dart';
import 'package:exd_social_app/controllers/image_picker_controller.dart';
import 'package:exd_social_app/controllers/signup_controller.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:exd_social_app/screens/home_screen.dart';
import 'package:exd_social_app/screens/signin_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  CollectionReference users = FirebaseFirestore.instance.collection("user");

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return GetBuilder<SignupController>(
      init: SignupController(),
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.dark),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          right: width * 0.05, left: width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GradientText(
                            'Signup',
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: "Pacifico",
                            ),
                            // ignore: prefer_const_literals_to_create_immutables
                            colors: [
                              Color.fromARGB(255, 248, 101, 148),
                              Color.fromARGB(255, 255, 202, 166),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              _.profileCroppedFile != null
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          left: width * 0.05,
                                          top: height * 0.027),
                                      height: height * 0.145,
                                      width: width * 0.3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        child: Image.file(
                                          _.profile_imageFile!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(
                                          left: width * 0.05,
                                          top: height * 0.027),
                                      height: height * 0.145,
                                      width: width * 0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        // ignore: prefer_const_literals_to_create_immutables
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0, 1),
                                              spreadRadius: 2,
                                              blurRadius: 2),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        child: Image.asset(
                                          "Assets/images/profile_image.jpeg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              Container(
                                height: height * 0.035,
                                width: width * 0.08,
                                margin: EdgeInsets.only(
                                    left: width * 0.3, top: height * 0.11),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 202, 166),
                                    // ignore: prefer_const_literals_to_create_immutables
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0, 1),
                                          spreadRadius: 2,
                                          blurRadius: 2),
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: InkWell(
                                  onTap: () async {
                                    _.profileImagePickerForProfile();
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.04,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: width * 0.07, right: width * 0.07),
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: _.validateName,
                                  controller: _.nameController,
                                  decoration: InputDecoration(
                                    hintText: _.hintName,
                                    hintStyle: TextStyle(
                                      fontFamily: "Josefin Sans",
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _.validateEmail,
                                  controller: _.emailController,
                                  decoration: InputDecoration(
                                    hintText: _.hintEmail,
                                    hintStyle: TextStyle(
                                      fontFamily: "Josefin Sans",
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Obx(() => TextFormField(
                                      validator: _.validatePassword,
                                      keyboardType: TextInputType.phone,
                                      obscureText: _.secure.value,
                                      controller: _.passwordController,
                                      decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                            fontFamily: "Josefin Sans",
                                            color: Colors.grey[400],
                                          ),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                _.isSecure();
                                              },
                                              icon: _.secure.value
                                                  ? Icon(
                                                      CupertinoIcons.eye_slash,
                                                      color: Color.fromARGB(
                                                          255, 46, 23, 15),
                                                    )
                                                  : Icon(
                                                      CupertinoIcons.eye,
                                                      color: Color.fromARGB(
                                                          255, 46, 23, 15),
                                                    )),
                                          hintText: _.hintPass),
                                    )),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                TextFormField(
                                  validator: _.validatePassword,
                                  keyboardType: TextInputType.phone,
                                  controller: _.phoneNumbController,
                                  decoration: InputDecoration(
                                    hintText: _.hintPhone,
                                    hintStyle: TextStyle(
                                      fontFamily: "Josefin Sans",
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Container(
                            // margin: EdgeInsets.only(left: 0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "May be i have an Account here?",
                                  style: TextStyle(fontFamily: "Josefin Sans"),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          RichText(
                            text: TextSpan(
                                text: "Societal: ",
                                style: TextStyle(
                                    fontFamily: "Josefin Sans",
                                    color: Colors.black,
                                    fontSize: 12),
                                children: [
                                  TextSpan(text: "Here is quick "),
                                  TextSpan(
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.to(SigninScreen(),
                                            transition:
                                                Transition.rightToLeftWithFade);
                                      },
                                    text: "SignIn",
                                    style: TextStyle(
                                      fontFamily: "Pacifico",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 248, 101, 148),
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: height * 0.06,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right: width * 0.05, left: width * 0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _.onSignUp();
                                        // _.uploadImageToStorage();
                                        Get.snackbar(
                                            backgroundGradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    255, 248, 101, 148),
                                                Color.fromARGB(
                                                    255, 255, 202, 166),
                                              ],
                                            ),
                                            "Signed-Up",
                                            "Successfully");
                                        Get.to(SigninScreen(),
                                            transition:
                                                Transition.rightToLeftWithFade);
                                      }
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 231, 231, 231),
                                                  offset: Offset(0, 3),
                                                  spreadRadius: 2,
                                                  blurRadius: 2),
                                            ],
                                            gradient: LinearGradient(colors: [
                                              Color.fromARGB(
                                                  255, 248, 101, 148),
                                              Color.fromARGB(
                                                  255, 255, 202, 166),
                                            ]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(150))),
                                        height: height * 0.11,
                                        width: width * 0.24,
                                        child: Text(
                                          "I'm In",
                                          style: TextStyle(
                                              fontFamily: "Josefin Sans",
                                              fontSize: 27,
                                              color: Colors.white),
                                        ))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
