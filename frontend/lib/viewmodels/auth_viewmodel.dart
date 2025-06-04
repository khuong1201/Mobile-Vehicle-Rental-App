import 'package:flutter/material.dart';
import 'package:frontend/api_services/verifyOTP_service.dart';
import '../api_services/login_service.dart';
import '../api_services/logout_service.dart';
import '../api_services/register_service.dart';

class AuthViewModel extends ChangeNotifier {
  String? token;
  String? email;
  bool isLoading = false;
  String? errorMessage;
  bool isOTPVerified = false;
  Future<bool> verifyOTP(String email, String otp) async {
    try {
      isLoading = true;
      errorMessage = null;
      isOTPVerified = false;
      notifyListeners();

      final response = await ApiVerifyOTP.register(email, otp);
      if (response != null) {
        debugPrint('OTP verification successful: $response');
        isOTPVerified = true;
        notifyListeners();
        return true;
      } else {
        debugPrint('OTP verification failed');
        errorMessage = 'OTP verification failed. Please try again.';
        isOTPVerified = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('OTP verification error: $e');
      errorMessage = 'An error occurred: $e';
      isOTPVerified = false;
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final backendToken = await ApiLogin.login(email, password);
      if (backendToken != null) {
        debugPrint('Login successful, token: $backendToken');
        token = backendToken;
        this.email = email;
        notifyListeners();
        return true;
      } else {
        debugPrint('Login False');
        errorMessage = 'Login failed. Please check your credentials.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      errorMessage = 'An error occurred: $e';
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await ApiRegister.register(email, password, name);
      if (response != null && response['success'] == true) {
        debugPrint('Registration successful: $response');
        this.email = email;
        notifyListeners();
        return true;
      } else {
        debugPrint('Registration failed');
        errorMessage = response['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      errorMessage = 'An error occurred: $e';
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logout(String accessToken, String userID) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await ApiLogout.logout(accessToken, userID);
      if (response != null) {
        debugPrint('Logout successful');
        token = null;
        email = null;
        notifyListeners();
        return true;
      } else {
        debugPrint('Logout failed');
        errorMessage = 'Logout failed. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Logout error: $e');
      errorMessage = 'An error occurred: $e';
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
