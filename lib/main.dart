import 'package:exd_social_app/screens/chatGPT_screen.dart';
import 'package:exd_social_app/screens/chats/chat.dart';
import 'package:exd_social_app/screens/chats/login.dart';
import 'package:exd_social_app/screens/home_screen.dart';
import 'package:exd_social_app/screens/post_screen.dart';
import 'package:exd_social_app/screens/signin_screen.dart';
import 'package:exd_social_app/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:page_transition/page_transition.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

getFCMToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM $token");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await getFCMToken();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState

    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        Get.snackbar(onTap: (snack) {
          Map<String, dynamic> data = message.data;

          if (data["isNotify"] == 0) {
            Get.to(ChatPage(
              room: data["room"],
            ));
          }
        }, "${message.notification!.title.toString().capitalizeFirst}",
            "${message.notification!.body.toString()}",
            backgroundGradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 248, 101, 148),
                Color.fromARGB(255, 255, 202, 166),
              ],
            ));
        print(
            'Message also contained a notification: ${message.notification!.title}');
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
          nextScreen: SigninScreen(),
          animationDuration: Duration(seconds: 3),
          splashTransition: SplashTransition.fadeTransition,
          // pageTransitionType: PageTransitionType.bottomToTop,
          curve: Curves.easeInCirc,
          splashIconSize: 600,
          splash: Container(
            child: Column(
              children: [
                Flexible(flex: 2, child: Container()),
                GradientText(
                  'Societal',
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: "Pacifico",
                  ),
                  colors: [
                    Color.fromARGB(255, 248, 101, 148),
                    Color.fromARGB(255, 255, 202, 166),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Flexible(flex: 2, child: Container()),
                GradientText(
                  'v 1.0',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Josefin Sans",
                  ),
                  colors: [
                    Color.fromARGB(255, 248, 101, 148),
                    Color.fromARGB(255, 255, 202, 166),
                  ],
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white),
    );
  }
}
