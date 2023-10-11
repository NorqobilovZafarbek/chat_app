import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../chat_page/chat_page.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({
    super.key,
    required this.document,
  });

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final QueryDocumentSnapshot? document;

  @override
  Widget build(BuildContext context) {
    Map<String, Object?> data = document?.data()! as Map<String, Object?>;
    if (_auth.currentUser?.email != data['email']) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                userEmail: '${data['name']}',
                userId: '${data['uid']}',
              ),
            ),
          );
        },
        child: SizedBox(
          height: 75,
          child: Card(
            elevation: 5,
            color: Colors.blue[400],
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${data['name']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
