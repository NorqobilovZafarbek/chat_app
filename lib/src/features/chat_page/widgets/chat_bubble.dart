import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {
  const Bubble({
    super.key,
    required this.text,
    required this.time,
    required this.crossAxisAlignment,
  });

  final String text;
  final String time;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  ChatItem({
    super.key,
    required this.document,
  });

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final QueryDocumentSnapshot? document;

  @override
  Widget build(BuildContext context) {
    Map<String, Object?> data = document?.data()! as Map<String, Object?>;

    Alignment alignment = (data['senderId'] == _auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    CrossAxisAlignment crossAxisAlignment =
        (data['senderId'] == _auth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start;

    final time = data['timestamp'] as Timestamp;

    final String date =
        '${time.toDate().year}/${time.toDate().month}/${time.toDate().day} ${time.toDate().hour}:${(time.toDate().minute).toString().padLeft(2, '0')}';

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(
              '${data['senderName']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Bubble(
              text: '${data['message']}',
              time: date,
              crossAxisAlignment: crossAxisAlignment,
            )
          ],
        ),
      ),
    );
  }
}
