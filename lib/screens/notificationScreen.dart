import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  TextEditingController receiverController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  String authKey =
      "AAAAfahnBCc:APA91bHTlgCgNtUQQF4Rcy9ODRW0TLxW2RuYdHUDfy7JjwpF7FUnzJY_vS1R2AjanwYbxbGo5tWUMWfxQKDJD1ZjWTScnwMSwsVcPljOvTHwh6xk1Q2o0bRV22DXSchFD4kfVJN7kRPY";

  String token =
      "fqDEOHmARh6j0x4ouIroa7:APA91bHNnLTKThB-wT7NCWtsXNcQ_pGPjrKDU_RtVUSNJ3Qcs4HUJqvQfqLBzoh9DeTW7rn5MR_-YhMm7tVQoz5O0iWf7kPvHLZg7uh3j_u1B6xOgrI6qZe7uCHMLQayUXHt0GDYzNK8";

  Future<void> sendMessage() async {
    Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");

    Map<String, dynamic> body = {
      "to": token,
      "notification": {"title": "Ali", "body": messageController},
      "data": {"title": "Title of Your Notification"}
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Message'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: InputDecoration(hintText: "To"),
          ),
          TextFormField(
            decoration: InputDecoration(hintText: "Message"),
          ),
          TextButton(onPressed: () {}, child: Text("Send")),
        ],
      ),
    );
  }
}
