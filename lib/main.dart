import 'package:exd_social_app/screens/chatGPT_screen.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
