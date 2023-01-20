import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:exd_social_app/screens/chat_message.dart';
import 'package:exd_social_app/screens/three_dots.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatGPTScreen extends StatefulWidget {
  const ChatGPTScreen({Key? key}) : super(key: key);

  @override
  State<ChatGPTScreen> createState() => _ChatGPTScreenState();
}

class _ChatGPTScreenState extends State<ChatGPTScreen> {
  ChatGPT? chatGPT;

  TextEditingController _controller = TextEditingController();
  bool _isImageSearch = false;
  bool _isTyping = false;
  final List<ChatMessage> _messages = [];
  StreamSubscription? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    chatGPT = ChatGPT.instance.builder(
      "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",
    );
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "user",
      time: DateFormat.Hms().format(DateTime.now()),
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    final request = CompleteReq(
        prompt: message.text, model: kTranslateModelV3, max_tokens: 200);

    _subscription = chatGPT!
        .builder("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",
            orgId: "")
        .onCompleteStream(request: request)
        .listen((response) {
      print(response!.choices[0].text);
      ChatMessage botMessage = ChatMessage(
        text: response.choices[0].text.toString(),
        sender: "Bot",
        time: DateFormat.Hms().format(DateTime.now()),
      );

      setState(() {
        _isTyping = false;
        _messages.insert(0, botMessage);
      });
    });
  }

  Widget _buildTextComposer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: const InputDecoration.collapsed(
                hintStyle: TextStyle(fontFamily: "Josefin Sans"),
                hintText: "Question/description"),
          ),
        ),
        ButtonBar(
          children: [
            IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Color.fromARGB(255, 248, 101, 148),
                size: 30,
              ),
              onPressed: () {
                _sendMessage();
              },
            ),
          ],
        ),
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Chat-Bot',
          style: TextStyle(
              fontSize: 28, fontFamily: "Pacifico", color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.all(8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _messages[index],
                      Divider(
                        height: height * 0.02,
                        indent: width * 0.13,
                        endIndent: width * 0.009,
                        color: Color.fromARGB(255, 248, 149, 149),
                      ),
                    ],
                  );
                }),
          ),
          _isTyping ? ThreeDots() : Container(),
          Container(
            child: _buildTextComposer(),
          )
        ],
      )),
    );
  }
}
