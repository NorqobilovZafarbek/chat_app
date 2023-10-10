import 'package:chat_app/src/common/widget/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'services/chat_service.dart';
import 'widgets/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.userEmail,
    required this.userId,
  });

  final String userEmail;
  final String userId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController _messageController;
  late final ChatService _chatService;
  late final FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _chatService = ChatService();
    _auth = FirebaseAuth.instance;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.userId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(widget.userEmail),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder(
              stream: _chatService.getMessages(
                  widget.userId, _auth.currentUser?.uid ?? ''),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      return ChatItem(document: snapshot.data?.docs[index]);
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextField(
                      isChat: true,
                      controller: _messageController,
                      textInputType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      hintText: 'Write a message',
                      isObscure: false,
                    ),
                  ),
                  IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.lightBlue,
                      size: 35,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
