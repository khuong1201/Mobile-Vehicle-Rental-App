import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api_service.dart';

class AuthViewModel extends ChangeNotifier {
  String? token;

  Future<void> login(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final idToken = await userCredential.user?.getIdToken();
      if (idToken != null) {
        final backendToken = await ApiService.sendTokenToBackend(idToken);
        if (backendToken != null) {
          token = backendToken;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }
  }

  void logout() {
    token = null;
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
