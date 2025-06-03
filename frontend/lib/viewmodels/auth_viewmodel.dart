import 'package:flutter/material.dart';
import '../api_services/login_service.dart';
import '../api_services/logout_service.dart';
import '../api_services/register_service.dart';

class AuthViewModel extends ChangeNotifier {
  String? token;
  String? email;
  Future<void> login(String email, String password) async {
    try {
      final backendToken = await ApiLogin.login(email, password);
      if (backendToken != null) {
        debugPrint('Login successful, token: $backendToken');
        token = backendToken;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      final response = await ApiRegister.register(email, password, name);
      if (response != null) {
        debugPrint('Registration successful: $response');
      }
    } catch (e) {
      debugPrint('Registration error: $e');
    }
  }

  Future<void> logout(String accessToken, String userID) async {
    try {
      final response = await ApiLogout.logout(accessToken, userID);
      if (response != null) {
        token = null; // Clear the token on logout
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
}
