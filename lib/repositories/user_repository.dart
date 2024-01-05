import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:habo/models/user_data.dart';

class UserRepository {
  UserRepository() : _firebaseAuth = FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<bool> signIn({required String email, required String password}) async {
    debugPrint("Trying to sign in");
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (_error, _stackTrace) {
      throw Exception('FirebaseException: $_error, found in: $_stackTrace');
    }
  }

  Future<UserData> signUp(
      {required String email, required String password}) async {
    try {
      final UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);
    } on FirebaseAuthException catch (_error, _stackTrace) {
      throw Exception('FirebaseException: $_error, found in: $_stackTrace');
    }
  }

  Future<void> signOut() {
    try {
      return _firebaseAuth.signOut();
    } on FirebaseAuthException catch (_error, _stackTrace) {
      throw Exception('FirebaseException: $_error, found in: $_stackTrace');
    }
  }

  bool isSignedIn() {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<UserData> getUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } on FirebaseException catch (_error, _stackTrace) {
      throw Exception('FirebaseException: $_error, found in: $_stackTrace');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Create user object based on the given User
  UserData _userFromFirebase(User? user) {
    if (user == null) {
      return UserData(email: "Null", uid: 'null');
    }

    return UserData(uid: user.uid, email: user.email!);
  }
}
