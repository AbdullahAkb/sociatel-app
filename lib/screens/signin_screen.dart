// ignore_for_file: prefer_const_constructors

import 'package:exd_social_app/controllers/signin_controller.dart';
import 'package:exd_social_app/screens/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<SigninController>(
      init: SigninController(),
      initState: (_) {},
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
                            'SignIn',
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
                    SizedBox(
                      height: height * 0.2,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: width * 0.07, right: width * 0.07),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        Text(
                                          "Email",
                                          style: TextStyle(
                                            fontFamily: "Josefin Sans",
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ]),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _.emailController,
                                    validator: _.validateEmail,
                                    decoration: InputDecoration(
                                        hintText: _.hintEmail.value,
                                        hintStyle: TextStyle(
                                          fontFamily: "Josefin Sans",
                                          color: Colors.grey[400],
                                        )),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        Text(
                                          "Password",
                                          style: TextStyle(
                                            fontFamily: "Josefin Sans",
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                      ]),
                                  Obx(() => TextFormField(
                                        keyboardType: TextInputType.phone,
                                        obscureText: _.secure.value,
                                        controller: _.passwordController,
                                        validator: _.validatePassword,
                                        decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  _.isSecure();
                                                },
                                                icon: _.secure.value
                                                    ? Icon(
                                                        CupertinoIcons
                                                            .eye_slash,
                                                        color: Color.fromARGB(
                                                            255, 46, 23, 15),
                                                      )
                                                    : Icon(
                                                        CupertinoIcons.eye,
                                                        color: Color.fromARGB(
                                                            255, 46, 23, 15),
                                                      )),
                                            hintText: _.hintPass.value,
                                            hintStyle: TextStyle(
                                              fontFamily: "Josefin Sans",
                                              color: Colors.grey[400],
                                            )),
                                      )),
                                  SizedBox(
                                    height: height * 0.05,
                                  ),
                                  SizedBox(
                                    height: height * 0.03,
                                  ),
                                  Container(
                                    // margin: EdgeInsets.only(left: 0.05),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Sorry it's my first time here!",
                                          style: TextStyle(
                                              fontFamily: "Josefin Sans"),
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
                                          TextSpan(text: "Ok, Here is quick "),
                                          TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Get.to(SignupScreen(),
                                                    transition: Transition
                                                        .leftToRightWithFade);
                                              },
                                            text: "SignUp",
                                            style: TextStyle(
                                              fontFamily: "Pacifico",
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 248, 101, 148),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: height * 0.06,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.only(
                          right: width * 0.05, left: width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  _.onPressed();
                                  Get.snackbar("SignIn", "Successfully",
                                      backgroundGradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 248, 101, 148),
                                          Color.fromARGB(255, 255, 202, 166),
                                        ],
                                      ));
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
                                        Color.fromARGB(255, 248, 101, 148),
                                        Color.fromARGB(255, 255, 202, 166),
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
            ),
          ),
        );
      },
    );
  }
}
