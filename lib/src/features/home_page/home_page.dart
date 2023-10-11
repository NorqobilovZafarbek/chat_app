import 'package:chat_app/src/features/auth_page/login_or_signin.dart';
import 'package:chat_app/src/features/auth_page/services/auth_service.dart';
import 'package:chat_app/src/features/home_page/widgets/custom_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Peoples',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginOrRegister(),
                  ),
                  (route) => false);
            },
            icon: const Icon(
              Icons.logout_outlined,
              size: 26,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SnackBar(
              content: Text('Error'),
              backgroundColor: Colors.red,
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return CustomListTile(document: snapshot.data?.docs[index]);
              },
              itemCount: snapshot.data?.docs.length ?? 0,
            ),
          );
        },
      ),
    );
  }
}
