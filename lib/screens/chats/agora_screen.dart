import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class AgoraScreen extends StatefulWidget {
  final types.Room room;
  const AgoraScreen({Key? key, required this.room}) : super(key: key);

  @override
  State<AgoraScreen> createState() => _AgoraScreenState();
}

class _AgoraScreenState extends State<AgoraScreen> {
  AgoraClient? client;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "290112d2f3c24f1eade2a10b62278db6",
        channelName: widget.room.id,
        username: "user",
      ),
      // enabledPermission: [Permission.camera, Permission.microphone],
    );
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              showAVState: true,
              client: client!,
              layoutType: Layout.floating,
              enableHostControls: true, // Add this to enable host controls
            ),
            AgoraVideoButtons(
              autoHideButtonTime: 3,
              client: client!,
            ),
          ],
        ),
      ),
    );
  }
}
