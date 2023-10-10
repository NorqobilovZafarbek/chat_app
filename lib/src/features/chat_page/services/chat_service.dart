import 'package:chat_app/src/common/entitys/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String msg) async {
    final String? currentUserId = _firebaseAuth.currentUser?.uid;
    final String? currentUserEmail = _firebaseAuth.currentUser?.email;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId ?? '',
      senderEmail: currentUserEmail ?? '',
      receiverId: receiverId,
      message: msg,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId ?? '', receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toJson());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
