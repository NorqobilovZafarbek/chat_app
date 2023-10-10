import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   sign user in method
  Future<UserCredential> signInWithEmailAndPassword(String email,
      String password,) async {
    try {
      UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    }
    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

//   create new user
  Future<UserCredential> signUpWhithEmailAndPassword(String email,
      String password,) async {
    try {
      UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// sign user out method
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
