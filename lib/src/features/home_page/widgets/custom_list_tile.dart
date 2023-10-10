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
      return ListTile(
        title: Text('${data['name']}'),
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
      );
    }
    return const SizedBox.shrink();
  }
}
