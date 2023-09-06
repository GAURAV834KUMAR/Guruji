import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:guruji/main.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  ScrollController scrollController = ScrollController();
  String? _messageContent, _chatId;
  final List<String> _logText = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initSDK();
    _addChatListener();
  }
  @override
  void dispose() {
    ChatClient.getInstance.chatManager.removeEventHandler("UNIQUE_HANDLER_ID");
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/1654671737698.jpg',
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
              child: Text(
                'Astro Name',
                style: FlutterFlowTheme.of(context).bodyText1,
              ),
            ),
          ],
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            const Text("login userId: ${AgoraChatConfig.userId}"),
            const Text("agoraToken: ${AgoraChatConfig.agoraToken}"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: _signIn,
                    child: const Text("SIGN IN"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: _signOut,
                    child: const Text("SIGN OUT"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.lightBlue),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter recipient's userId",
              ),
              onChanged: (chatId) => _chatId = chatId,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter message",
              ),
              onChanged: (msg) => _messageContent = msg,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _sendMessage,
              child: const Text("SEND TEXT"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
              ),
            ),
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (_, index) {
                  return Text(_logText[index]);
                },
                itemCount: _logText.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
void _initSDK() async {
  ChatOptions options = ChatOptions(
    appKey: AgoraChatConfig.appKey,
    autoLogin: false,
  );
  await ChatClient.getInstance.init(options);
}
  void _addChatListener() {
    ChatClient.getInstance.chatManager.addEventHandler(
      "UNIQUE_HANDLER_ID",
      ChatEventHandler(onMessagesReceived: onMessagesReceived),
    );
  }
void _signIn() async {
  try {
    await ChatClient.getInstance.loginWithAgoraToken(
      AgoraChatConfig.userId,
      AgoraChatConfig.agoraToken,
    );
    _addLogToConsole("login succeed, userId: ${AgoraChatConfig.userId}");
  } on ChatError catch (e) {
    _addLogToConsole("login failed, code: ${e.code}, desc: ${e.description}");
  }
}
void _signOut() async {
  try {
    await ChatClient.getInstance.logout(true);
    _addLogToConsole("sign out succeed");
  } on ChatError catch (e) {
    _addLogToConsole(
        "sign out failed, code: ${e.code}, desc: ${e.description}");
  }
}
void _sendMessage() async {
  if (_chatId == null || _messageContent == null) {
    _addLogToConsole("single chat id or message content is null");
    return;
  }

  var msg = ChatMessage.createTxtSendMessage(
    targetId: _chatId!,
    content: _messageContent!,
  );
  msg.setMessageStatusCallBack(MessageStatusCallBack(
    onSuccess: () {
      _addLogToConsole("send message: $_messageContent");
    },
    onError: (e) {
      _addLogToConsole(
        "send message failed, code: ${e.code}, desc: ${e.description}",
      );
    },
  ));
  ChatClient.getInstance.chatManager.sendMessage(msg);
}
void onMessagesReceived(List<ChatMessage> messages) {
  for (var msg in messages) {
    switch (msg.body.type) {
      case MessageType.TXT:
        {
          ChatTextMessageBody body = msg.body as ChatTextMessageBody;
          _addLogToConsole(
            "receive text message: ${body.content}, from: ${msg.from}",
          );
        }
        break;
      case MessageType.IMAGE:
        {
          _addLogToConsole(
            "receive image message, from: ${msg.from}",
          );
        }
        break;
      case MessageType.VIDEO:
        {
          _addLogToConsole(
            "receive video message, from: ${msg.from}",
          );
        }
        break;
      case MessageType.LOCATION:
        {
          _addLogToConsole(
            "receive location message, from: ${msg.from}",
          );
        }
        break;
      case MessageType.VOICE:
        {
          _addLogToConsole(
            "receive voice message, from: ${msg.from}",
          );
        }
        break;
      case MessageType.FILE:
        {
          _addLogToConsole(
            "receive image message, from: ${msg.from}",
          );
        }
        break;
      case MessageType.CUSTOM:
        {
          _addLogToConsole(
            "receive custom message, from: ${msg.from}",
          );
        }
        break;
      case MessageType.CMD:
        {}
        break;
    }
  }
}

  void _addLogToConsole(String log) {
    _logText.add(_timeString + ": " + log);
    setState(() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }
  String get _timeString {
    return DateTime.now().toString().split(".").first;
  }
}

