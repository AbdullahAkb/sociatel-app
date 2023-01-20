import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exd_social_app/db/firestore_db.dart';
import 'package:exd_social_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart' as uuid;

//
//
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  final types.User currentUser;

  ChatPage({super.key, required this.receiverUser, required this.currentUser});

  final types.User receiverUser;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];

  @override
  void initState() {
    super.initState();

    _loadMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
    _addMessageToFirebase(message);
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  // void _handleFileSelection() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.any,
  //   );
  //
  //   if (result != null && result.files.single.path != null) {
  //     final message = types.FileMessage(
  //       author: _user,
  //       createdAt: DateTime.now().millisecondsSinceEpoch,
  //       id: const Uuid().v4(),
  //       mimeType: lookupMimeType(result.files.single.path!),
  //       name: result.files.single.name,
  //       size: result.files.single.size,
  //       uri: result.files.single.path!,
  //     );
  //
  //     _addMessage(message);
  //   }
  // }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: widget.currentUser,
        createdAt: DateFormat.Hms().format(DateTime.now()) as int,
        height: image.height.toDouble(),
        id: "0",
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  // void _handleMessageTap(BuildContext _, types.Message message) async {
  //   if (message is types.FileMessage) {
  //     var localPath = message.uri;
  //
  //     if (message.uri.startsWith('http')) {
  //       try {
  //         final index =
  //         _messages.indexWhere((element) => element.id == message.id);
  //         final updatedMessage =
  //         (_messages[index] as types.FileMessage).copyWith(
  //           isLoading: true,
  //         );
  //
  //         setState(() {
  //           _messages[index] = updatedMessage;
  //         });
  //
  //         final client = http.Client();
  //         final request = await client.get(Uri.parse(message.uri));
  //         final bytes = request.bodyBytes;
  //         final documentsDir = (await getApplicationDocumentsDirectory()).path;
  //         localPath = '$documentsDir/${message.name}';
  //
  //         if (!File(localPath).existsSync()) {
  //           final file = File(localPath);
  //           await file.writeAsBytes(bytes);
  //         }
  //       } finally {
  //         final index =
  //         _messages.indexWhere((element) => element.id == message.id);
  //         final updatedMessage =
  //         (_messages[index] as types.FileMessage).copyWith(
  //           isLoading: null,
  //         );
  //
  //         setState(() {
  //           _messages[index] = updatedMessage;
  //         });
  //       }
  //     }
  //
  //     await OpenFilex.open(localPath);
  //   }
  // }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
        author: widget.currentUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: uuid.Uuid().v1(),
        text: message.text,
        remoteId: widget.receiverUser.id);

    _addMessage(textMessage);
  }

  _addMessageToFirebase(types.Message message) async {
    CollectionReference chatReference =
        FirebaseFirestore.instance.collection("chat");

    chatReference.add(message.toJson());
  }

  void _loadMessages() async {
    CollectionReference chatReference =
        FirebaseFirestore.instance.collection("chat");
    chatReference
        .where("remoteId", isEqualTo: widget.receiverUser.id)
        .where("id", isEqualTo: widget.currentUser.id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        _messages.insert(0, types.Message.fromJson(docData));
      }
      setState(() {});
    }).onError((error, stackTrace) {
      print("$error");
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(
              height: height * 0.057,
              width: width * 0.125,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: Image.network(
                  widget.receiverUser.imageUrl.toString(),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(
              width: width * 0.05,
            ),
            Text(
              widget.receiverUser.firstName.toString(),
              style: TextStyle(
                  fontFamily: "Josefin Sans",
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
          children: [
            Expanded(
              child: Chat(
                messages: _messages,
                onAttachmentPressed: _handleAttachmentPressed,
                // onMessageTap: _handleMessageTap,
                onPreviewDataFetched: _handlePreviewDataFetched,
                onSendPressed: _handleSendPressed,
                showUserAvatars: true,
                showUserNames: true,
                user: widget.currentUser,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
