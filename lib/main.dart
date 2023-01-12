import 'package:exd_social_app/screens/home_screen.dart';
import 'package:exd_social_app/screens/post_screen.dart';
import 'package:exd_social_app/screens/signin_screen.dart';
import 'package:exd_social_app/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      home: SigninScreen(),
    );
  }
}