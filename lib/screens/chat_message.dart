import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String sender;
  final String time;

  ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
      required this.time});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: width * 0.02),
              child: CircleAvatar(
                backgroundColor: sender != "Bot" ? Colors.blue : Colors.green,
                child: Text(
                  textAlign: TextAlign.center,
                  sender,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontFamily: "Josefin Sans"),
                ),
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(sender,
                        style: TextStyle(
                          fontFamily: "Josefin Sans",
                          fontSize: 20,
                          color: sender != "Bot"
                              ? Color.fromARGB(255, 248, 101, 148)
                              : Colors.green,
                        )),
                    Text(time)
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  margin: EdgeInsets.only(top: height * 0.001),
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Josefin Sans",
                        color: Color.fromARGB(255, 46, 46, 46)),
                  ),
                )
              ],
            ))
          ],
        ),
        SizedBox(
          height: height * 0.01,
        )
      ],
    );
  }
}
