import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/controllers/image_picker_controller.dart';
import 'package:exd_social_app/models/post_model.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  TextEditingController postTextController = TextEditingController();
  CollectionReference usersReference =
      FirebaseFirestore.instance.collection("user");
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<UserModel> userData() async {
    DocumentSnapshot userData =
        await usersReference.doc(currentUser!.uid).get();

    UserModel data = UserModel.fromDocumentSnapshot(userData);

    return data;
  }

  addPost(String userImage, String postImage) async {}

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: animationController);
    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GetBuilder<ImagePickerController>(
      init: ImagePickerController(),
      builder: (_) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionBubble(
              items: [
                Bubble(
                  title: "Camera",
                  iconColor: Colors.blueAccent,
                  bubbleColor: Colors.white,
                  icon: CupertinoIcons.camera,
                  titleStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.blueAccent,
                      fontFamily: "Josefin Sans"),
                  onPress: () async {
                    await _.imagePickerForPostFromCamera();
                    animationController.reverse();
                  },
                ),
                Bubble(
                  title: "Gallery",
                  iconColor: Colors.greenAccent,
                  bubbleColor: Colors.white,
                  icon: Icons.photo_library_rounded,
                  titleStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.greenAccent,
                      fontFamily: "Josefin Sans"),
                  onPress: () async {
                    _.imagePickerForPostFromGallery();
                    animationController.reverse();
                  },
                ),
              ],
              onPress: () {
                animationController.isCompleted
                    ? animationController.reverse()
                    : animationController.forward();
              },
              iconColor: Color.fromARGB(255, 248, 101, 148),
              iconData: Icons.add_a_photo_outlined,
              backGroundColor: Colors.black,
              animation: animation),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: GradientText(
              'Craete Post',
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Pacifico",
              ),
              colors: [
                Color.fromARGB(255, 248, 101, 148),
                Color.fromARGB(255, 255, 202, 166),
              ],
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.white),
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                )),
            actions: [
              TextButton(
                  style: ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  onPressed: () async {
                    if (_.postTextController.text.isEmpty &&
                        _.postTextController.text == null) {
                      Get.defaultDialog(
                          title: "Alert",
                          middleText:
                              "Your Post Can't be Empty.So, add some text or Image.",
                          middleTextStyle:
                              TextStyle(fontFamily: "Josefin Sans"),
                          titleStyle: TextStyle(fontFamily: "Josefin Sans"));
                    } else {
                      await _.postToFirestore();
                      Get.back();
                    }
                  },
                  child: Text(
                    "Post",
                    style: TextStyle(
                        fontFamily: "Josefin Sans",
                        fontSize: 20,
                        color: _.croppedPostImage != null ||
                                _.postTextController.text.isNotEmpty
                            ? Colors.blueAccent
                            : Colors.grey),
                  ))
            ],
            elevation: 3,
            shadowColor: Color.fromARGB(255, 248, 101, 148),
          ),
          body: Column(
            children: [
              SizedBox(
                height: height * 0.015,
              ),
              FutureBuilder<UserModel>(
                future: userData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    UserModel detail = snapshot.data!;
                    return Row(
                      children: [
                        SizedBox(
                          width: width * 0.05,
                        ),
                        Container(
                          height: height * 0.067,
                          width: width * 0.145,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            child: Image.network(
                              detail.profileImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.04,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.008,
                            ),
                            Text(
                              detail.name,
                              style: TextStyle(
                                  fontFamily: "Josefin Sans",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: height * 0.008,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  Icon(
                                    CupertinoIcons.globe,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: width * 0.009,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: height * 0.003),
                                    child: Text(
                                      "Public",
                                      style: TextStyle(
                                        fontFamily: "Josefin Sans",
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  }
                  return Container();
                },
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                              left: width * 0.05, right: width * 0.05),
                          child: TextFormField(
                            // autofocus: true,
                            controller: _.postTextController,
                            cursorWidth: 2,
                            cursorColor: Color.fromARGB(255, 248, 101, 148),
                            cursorHeight: 27,
                            style: TextStyle(
                                fontFamily: "Josefin Sans", fontSize: 27),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              hintText: "Let's Write Something!",
                              hintStyle: TextStyle(
                                fontFamily: "Josefin Sans",
                                fontSize: 27,
                                color: Color.fromARGB(255, 187, 187, 187),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      _.croppedPostImage != null
                          ? Container(
                              height: height * 0.5,
                              width: width,
                              child: ClipRRect(
                                child: Image.file(
                                  _.postImage!,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
