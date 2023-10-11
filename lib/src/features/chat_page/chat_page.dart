import 'package:chat_app/src/common/widget/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  late final FirebaseFirestore _firestore;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _chatService = ChatService();
    _scrollController = ScrollController();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    final userInfo =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          userInfo['name'], widget.userId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: Text(
          widget.userEmail,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
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

                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 1),
                      curve: Curves.fastOutSlowIn);
                });

                return Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
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
                      hintText: 'Write a message...',
                      isObscure: false,
                    ),
                  ),
                  IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.blueAccent,
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
