import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/login_service.dart';
import 'package:frontend/api_services/logout_service.dart';
import 'package:frontend/api_services/register_service.dart';
import 'package:frontend/api_services/verify_otp_service.dart';
import 'package:frontend/api_services/token_service.dart';
import '/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthViewModel extends ChangeNotifier {
  User? user;
  bool isLoading = false;
  String? errorMessage;
  bool isOTPVerified = false;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final TokenService _tokenService = TokenService();

  // Check login status
  Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    final user = await getUser();
    return accessToken != null && user != null;
  }

  // Get accessToken
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: 'accessToken');
    } catch (e) {
      debugPrint('Error reading accessToken: $e');
      return null;
    }
  }

  // Get user data
  Future<User?> getUser() async {
    try {
      final userJson = await _secureStorage.read(key: 'user');
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      }
      return null;
    } catch (e) {
      debugPrint('Error reading user data: $e');
      return null;
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    final success = await _tokenService.refreshToken();
    if (success) {
      notifyListeners();
    }
    return success;
  }

  // Verify OTP
  Future<bool> verifyOTP(String email, String otp) async {
    try {
      isLoading = true;
      errorMessage = null;
      isOTPVerified = false;
      notifyListeners();

      final response = await ApiVerifyOTP.verifyOTP(email, otp);
      if (response.success) {
        debugPrint('OTP verification successful: ${response.message}');
        isOTPVerified = true;
        notifyListeners();
        return true;
      } else {
        debugPrint('OTP verification failed: ${response.message}');
        errorMessage = response.message ?? 'OTP verification failed.';
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

  // Login
  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await ApiLogin.login(email, password);
      if (response.success && response.data != null) {
        final userData = response.data!['user'] as Map<String, dynamic>?;
        if (userData == null) {
          debugPrint('Invalid login response: missing user data');
          errorMessage = 'Invalid user data.';
          notifyListeners();
          return false;
        }

        user = User.fromJson(userData);
        debugPrint('Login successful: ${user!.email}');
        notifyListeners();
        return true;
      } else {
        debugPrint('Login failed: ${response.message}');
        errorMessage = response.message ?? 'Incorrect login information.';
        notifyListeners();
        return false;
      }
    } catch (err, stackTrace) {
      debugPrint('Login error: $err\n$stackTrace');
      errorMessage = 'An error occurred: $err';
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Register
  Future<bool> register(String email, String password, String name) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await ApiRegister.register(email, password, name);
      if (response.success) {
        debugPrint('Registration successful: ${response.message}');
        user = User(
          id: '',
          userId: '',
          fullName: name,
          email: email,
          role: 'renter',
          verified: false,
        );
        notifyListeners();
        return true;
      } else {
        debugPrint('Registration failed: ${response.message}');
        errorMessage = response.message ?? 'Registration failed.';
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

  // Logout
  Future<bool> logout() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await ApiLogout.logout();
      if (response.success) {
        debugPrint('Logout successful: ${response.message}');
        user = null;
        await _secureStorage.delete(key: 'accessToken');
        await _secureStorage.delete(key: 'refreshToken');
        await _secureStorage.delete(key: 'user');
        notifyListeners();
        return true;
      } else {
        debugPrint('Logout failed: ${response.message}');
        errorMessage = response.message ?? 'Logout failed.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Logout error: $e');
      errorMessage = 'An error occurred.';
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
