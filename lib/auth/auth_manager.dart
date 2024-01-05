import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habo/models/user_data.dart';
import 'package:habo/repositories/user_repository.dart';
import 'package:habo/utils/dependency_injector.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
  registering
}

class AuthManager with ChangeNotifier {
  late final UserRepository _userRepository;

  UserData _user = UserData(uid: "Null", email: "Null");
  bool _isInitialized = false;

  Status _status = Status.uninitialized;

  Status get status => _status;

  UserData get user => _user;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    _userRepository = await DependencyInjector.getUserRepository();
    _userRepository.authStateChanges.listen(onAuthStateChanged);
    _user = await _userRepository.getUser();
    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      bool result =
          await _userRepository.signIn(email: email, password: password);
      _user = await _userRepository.getUser();
      return result;
    } catch (e) {
      // Handle exceptions
      _status = Status.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      _status = Status.registering;
      notifyListeners();
      _user = await _userRepository.signUp(email: email, password: password);
    } catch (e) {
      _status = Status.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    reset();
    _userRepository.signOut();
    _status = Status.unauthenticated;
    notifyListeners();
  }

  Future<void> onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.unauthenticated;
    } else {
      _status = Status.authenticated;
    }
    notifyListeners();
  }

  //Method to handle password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _userRepository.sendPasswordResetEmail(email);
  }

  void reset() {
    _isInitialized = false;
    _status = Status.uninitialized;
  }
}
