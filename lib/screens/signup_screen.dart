import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/auth/firebase_auth.dart';
import 'package:exd_social_app/controllers/image_picker_controller.dart';
import 'package:exd_social_app/controllers/signup_controller.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey();
  CollectionReference users = FirebaseFirestore.instance.collection("user");

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return GetBuilder<SignupController>(
      init: SignupController(),
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(
                  onPressed: () {},
                  child: Text(
                    "upload",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
            title: Text("SignUp"),
          ),
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    _.profileCroppedFile != null
                        ? Container(
                            margin: EdgeInsets.only(
                                left: width * 0.05, top: height * 0.027),
                            height: height * 0.145,
                            width: width * 0.3,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              child: Image.file(
                                _.profile_imageFile!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(
                                left: width * 0.05, top: height * 0.027),
                            height: height * 0.145,
                            width: width * 0.3,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              child: Image.asset(
                                "Assets/images/profile_image.jpeg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    InkWell(
                      onTap: () async {
                        _.profileImagePickerForProfile();
                      },
                      child: Container(
                        height: height * 0.035,
                        width: width * 0.08,
                        margin: EdgeInsets.only(
                            left: width * 0.3, top: height * 0.11),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 176, 254, 236),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Icon(
                          Icons.edit,
                          size: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  validator: _.validateName,
                  controller: _.nameController,
                  decoration: InputDecoration(hintText: _.hintName),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: _.validateEmail,
                  controller: _.emailController,
                  decoration: InputDecoration(hintText: _.hintEmail),
                ),
                Obx(() => TextFormField(
                      validator: _.validatePassword,
                      keyboardType: TextInputType.phone,
                      obscureText: _.secure.value,
                      controller: _.passwordController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                _.isSecure();
                              },
                              icon: _.secure.value
                                  ? Icon(
                                      CupertinoIcons.eye_slash,
                                      color: Color.fromARGB(255, 46, 23, 15),
                                    )
                                  : Icon(
                                      CupertinoIcons.eye,
                                      color: Color.fromARGB(255, 46, 23, 15),
                                    )),
                          hintText: _.hintPass),
                    )),
                TextFormField(
                  validator: _.validatePassword,
                  keyboardType: TextInputType.phone,
                  controller: _.phoneNumbController,
                  decoration: InputDecoration(hintText: _.hintPhone),
                ),
                TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _.onSignUp();
                        await _.uploadImageToStorage();
                        Get.snackbar("Signed-Up", "Successfully");
                      }
                    },
                    child: Text("SignUp"))
              ],
            ),
          ),
        );
      },
    );
  }
}
