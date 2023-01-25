import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/auth/firebase_auth.dart';
import 'package:exd_social_app/controllers/home_screen_controller.dart';
import 'package:exd_social_app/models/post_model.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:exd_social_app/screens/chatGPT_screen.dart';
import 'package:exd_social_app/screens/chats/login.dart';
import 'package:exd_social_app/screens/chats/rooms.dart';
import 'package:exd_social_app/screens/location_screen.dart';
import 'package:exd_social_app/screens/signin_screen.dart';
import 'package:exd_social_app/screens/userChats_screen.dart';
import 'package:exd_social_app/screens/comment_screen.dart';
import 'package:exd_social_app/screens/post_screen.dart';
import 'package:exd_social_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:app_settings/app_settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  CollectionReference usersReference =
      FirebaseFirestore.instance.collection("users");
  User? current = FirebaseAuth.instance.currentUser;

  bool details = false;

  setDetails() {
    details = !details;
    setState(() {});
  }

  Future<UserModel> userData() async {
    print(current!.uid);
    DocumentSnapshot userData = await usersReference.doc(current!.uid).get();

    UserModel data =
        UserModel.fromjson(userData.data() as Map<String, dynamic>);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder<UserModel>(
      future: userData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(
                color: Color.fromARGB(255, 248, 101, 148),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          UserModel data = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            drawer: Container(
              // margin: EdgeInsets.only(top: height * 0.045),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                topRight: Radius.circular(70),
              )),
              child: Drawer(
                backgroundColor: Colors.white,
                elevation: 40,
                surfaceTintColor: Color.fromARGB(255, 248, 101, 148),
                shadowColor: Color.fromARGB(255, 248, 101, 148),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(30),
                )),
                width: width * 0.7,
                child: Column(
                  children: [
                    UserAccountsDrawerHeader(
                        margin: EdgeInsets.only(top: height * 0.04),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 248, 101, 148),
                            Color.fromARGB(255, 255, 202, 166),

                            // Color.fromARGB(255, 248, 101, 148),
                            // Color.fromARGB(255, 255, 202, 166),
                          ]),
                        ),
                        currentAccountPicture: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            child: Image.network(
                              data.metaData.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        accountName: Text(snapshot.data!.name,
                            style: TextStyle(fontFamily: "Josefin Sans")),
                        accountEmail: Text(
                          // "h",
                          snapshot.data!.metaData.email,
                          style: TextStyle(fontFamily: "Josefin Sans"),
                        )),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    ListTile(
                      splashColor: Color.fromARGB(255, 255, 202, 166),
                      onTap: () {
                        Get.to(
                            ProfileScreen(
                              details: snapshot.data!,
                            ),
                            transition: Transition.rightToLeftWithFade);
                      },
                      leading: Icon(CupertinoIcons.person, size: 20),
                      title: Text(
                        "Profile",
                        style: TextStyle(fontFamily: "Josefin Sans"),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Color.fromARGB(255, 248, 101, 148),
                      ),
                    ),
                    Divider(
                      height: 0,
                      indent: width * 0.1,
                      endIndent: width * 0.1,
                      color: Color.fromARGB(255, 255, 202, 166),
                    ),
                    ListTile(
                      splashColor: Color.fromARGB(255, 255, 202, 166),
                      onTap: () {},
                      leading: Icon(CupertinoIcons.person_2, size: 20),
                      title: Text(
                        "Friends",
                        style: TextStyle(fontFamily: "Josefin Sans"),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Color.fromARGB(255, 248, 101, 148),
                      ),
                    ),
                    Divider(
                      height: 0,
                      indent: width * 0.1,
                      endIndent: width * 0.1,
                      color: Color.fromARGB(255, 255, 202, 166),
                    ),
                    ListTile(
                      splashColor: Color.fromARGB(255, 255, 202, 166),
                      onTap: () {
                        Get.to(RoomsPage(),
                            transition: Transition.rightToLeftWithFade);
                      },
                      leading: Icon(Icons.message_rounded, size: 20),
                      title: Text(
                        "Messages",
                        style: TextStyle(fontFamily: "Josefin Sans"),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Color.fromARGB(255, 248, 101, 148),
                      ),
                    ),
                    Divider(
                      height: 0,
                      indent: width * 0.1,
                      endIndent: width * 0.1,
                      color: Color.fromARGB(255, 255, 202, 166),
                    ),
                    ListTile(
                      splashColor: Color.fromARGB(255, 255, 202, 166),
                      onTap: () {
                        Get.to(LocationScreen(),
                            transition: Transition.rightToLeftWithFade);
                      },
                      leading: Icon(CupertinoIcons.location, size: 20),
                      title: Text(
                        "Location",
                        style: TextStyle(fontFamily: "Josefin Sans"),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Color.fromARGB(255, 248, 101, 148),
                      ),
                    ),
                    Divider(
                      height: 0,
                      indent: width * 0.1,
                      endIndent: width * 0.1,
                      color: Color.fromARGB(255, 255, 202, 166),
                    ),
                    ListTile(
                      splashColor: Color.fromARGB(255, 255, 202, 166),
                      onTap: () {
                        Get.to(ChatGPTScreen(),
                            transition: Transition.rightToLeftWithFade);
                      },
                      leading: Image.asset(
                        "Assets/images/robot.png",
                        height: height * 0.028,
                      ),
                      title: Text(
                        "Chat Bot",
                        style: TextStyle(fontFamily: "Josefin Sans"),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Color.fromARGB(255, 248, 101, 148),
                      ),
                    ),
                    Divider(
                      height: 0,
                      indent: width * 0.1,
                      endIndent: width * 0.1,
                      color: Color.fromARGB(255, 255, 202, 166),
                    ),
                    Expanded(
                      child: Container(),
                      flex: 1,
                    ),
                    ListTile(
                      splashColor: Color.fromARGB(255, 255, 202, 166),
                      onTap: () async {
                        bool status;
                        status = await Auth.signOut();
                        status
                            ? Get.to(SigninScreen(),
                                transition: Transition.leftToRightWithFade)
                            : printError(info: "error");
                      },
                      title: Text(
                        "LogOut",
                        style: TextStyle(fontFamily: "Josefin Sans"),
                      ),
                      leading: Icon(Icons.output_rounded, size: 20),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Color.fromARGB(255, 248, 101, 148),
                      ),
                    ),
                    Divider(
                      height: 0,
                      indent: width * 0.1,
                      endIndent: width * 0.1,
                      color: Color.fromARGB(255, 255, 202, 166),
                    ),
                    ListTile(
                      splashColor: Color.fromARGB(255, 255, 202, 166),
                      onTap: () {
                        AppSettings.openAppSettings();
                      },
                      leading: Icon(CupertinoIcons.settings, size: 20),
                      title: Text(
                        "App Settings",
                        style: TextStyle(fontFamily: "Josefin Sans"),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Color.fromARGB(255, 248, 101, 148),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              elevation: 0,
              // shadowColor: Color.fromARGB(255, 248, 101, 148),
              automaticallyImplyLeading: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark,
                  statusBarColor: Colors.white),

              backgroundColor: Colors.white,
              // centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  size: 25,
                  color: Color.fromARGB(255, 36, 55, 72),
                ),
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
              title: GradientText(
                'Societal',
                style: TextStyle(
                  fontSize: 35,
                  fontFamily: "Pacifico",
                ),
                colors: [
                  Color.fromARGB(255, 248, 101, 148),
                  Color.fromARGB(255, 255, 202, 166),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Get.to(RoomsPage(),
                          transition: Transition.rightToLeftWithFade);
                    },
                    icon: Icon(
                      CupertinoIcons.paperplane,
                      color: Color.fromARGB(255, 36, 55, 72),
                    ))
              ],
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: width * 0.02,
                          right: width * 0.02,
                          top: height * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: height * 0.067,
                            width: width * 0.14,
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(
                                        ProfileScreen(
                                          details: data,
                                        ),
                                        transition:
                                            Transition.rightToLeftWithFade);
                                  },
                                  child: Image.network(
                                    data.metaData.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ),
                          Container(
                            height: height * 0.055,
                            width: width * 0.6,
                            child: TextFormField(
                              keyboardType: TextInputType.none,
                              showCursor: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: height * 0.01, left: width * 0.05),
                                hintText: "Tell Something to Everyone...",
                                hintStyle: TextStyle(
                                    fontFamily: "Josefin Sans", fontSize: 13),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40)),
                                    borderSide: BorderSide(color: Colors.grey)),
                              ),
                              onTap: () {
                                Get.to(PostScreen(details: data),
                                    transition: Transition.downToUp);
                              },
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                // Auth.signOut();
                                // Get.back();
                              },
                              icon: Icon(
                                Icons.photo_library_rounded,
                                color: Colors.greenAccent,
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Divider(
                      thickness: height * 0.01,
                      height: height * 0.04,
                    ),
                    ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(
                              //   height: height * 0.01,
                              // ),

                              Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.03, right: width * 0.03),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: height * 0.065,
                                      width: width * 0.14,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        child: Image.asset(
                                          "Assets/images/postpic.jpg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: height * 0.013,
                                        ),
                                        Text(
                                          "Abdullah",
                                          style: TextStyle(
                                              fontFamily: "Josefin Sans",
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Text(
                                          "2 min ago",
                                          style: TextStyle(
                                              fontFamily: "Josefin Sans",
                                              color: Color.fromARGB(
                                                  255, 248, 101, 148)),
                                        ),
                                      ],
                                    ),
                                    Expanded(child: Container()),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.more_horiz_rounded)),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          CupertinoIcons.clear,
                                          size: 20,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.03, right: width * 0.03),
                                child: Text(
                                  "G.O.A.T ",
                                  style: TextStyle(
                                      fontFamily: "Josefin Sans", fontSize: 15),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                height: height * 0.4,
                                width: width,
                                child: Image.asset(
                                  "Assets/images/postbody.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.015,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.03, right: width * 0.03),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "1.2k ",
                                      style:
                                          TextStyle(fontFamily: "Josefin Sans"),
                                    ),
                                    Text(
                                      "129comments",
                                      style:
                                          TextStyle(fontFamily: "Josefin Sans"),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.hand_thumbsup,
                                              color: Colors.pinkAccent,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: width * 0.01,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: height * 0.008),
                                              child: Text(
                                                "Like",
                                                style: TextStyle(
                                                    fontFamily: "Josefin Sans",
                                                    color: Color.fromARGB(
                                                        255, 132, 132, 132)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: height * 0.008),
                                              child: Icon(
                                                Icons.messenger_outline,
                                                color: Colors.greenAccent,
                                                size: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.01,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: height * 0.008),
                                              child: Text(
                                                "Comment",
                                                style: TextStyle(
                                                    fontFamily: "Josefin Sans",
                                                    color: Color.fromARGB(
                                                        255, 132, 132, 132)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.ios_share_rounded,
                                              color: Colors.blueAccent,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: width * 0.01,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                top: height * 0.008,
                                              ),
                                              child: Text(
                                                "Share",
                                                style: TextStyle(
                                                    fontFamily: "Josefin Sans",
                                                    color: Color.fromARGB(
                                                        255, 132, 132, 132)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: height * 0.01,
                                height: height * 0.05,
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
