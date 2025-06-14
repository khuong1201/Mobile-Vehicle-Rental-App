import 'package:flutter/material.dart';
import 'package:frontend/api_services/login_service.dart';
import 'package:frontend/api_services/logout_service.dart';
import 'package:frontend/api_services/register_service.dart';
import 'package:frontend/api_services/verify_otp_service.dart';
import 'package:frontend/api_services/token_service.dart';
import '/models/user.dart';
import 'user_secure_storage.dart';

class AuthViewModel extends ChangeNotifier {
  User? user;
  bool isLoading = false;
  String? errorMessage;
  bool isOTPVerified = false;
  final TokenService _tokenService = TokenService();

  Future<bool> isLoggedIn() async {
    final accessToken = await UserSecureStorage.getAccessToken();
    final user = await UserSecureStorage.getUser();
    return accessToken != null && user != null;
  }

  Future<void> _updateState({bool loading = false, String? error, bool notify = true}) async {
    isLoading = loading;
    errorMessage = error;
    if (notify) notifyListeners();
  }

  Future<bool> verifyOTP(String email, String otp) async {
    try {
      await _updateState(loading: true);
      final response = await ApiVerifyOTP.verifyOTP(email, otp);
      isOTPVerified = response.success;
      await _updateState(error: response.success ? null : response.message ?? 'OTP verification failed.');
      return response.success;
    } catch (e) {
      await _updateState(error: 'An error occurred: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await _updateState(loading: true);
      final response = await ApiLogin.login(email, password);
      if (response.success && response.data != null) {
        final userData = response.data!['user'] as Map<String, dynamic>?;
        if (userData == null) {
          await _updateState(error: 'Invalid user data.');
          return false;
        }
        user = User.fromJson(userData);
        await UserSecureStorage.saveUser(user!);
        await _updateState();
        return true;
      }
      await _updateState(error: response.message ?? 'Incorrect login information.');
      return false;
    } catch (e) {
      await _updateState(error: 'An error occurred: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      await _updateState(loading: true);
      final response = await ApiRegister.register(email, password, name);
      if (response.success) {
        user = User(
          id: '',
          userId: '',
          fullName: name,
          email: email,
          imageAvatarUrl: '',
          role: 'renter',
          verified: false,
        );
        await UserSecureStorage.saveUser(user!);
        await _updateState();
        return true;
      }
      await _updateState(error: response.message ?? 'Registration failed.');
      return false;
    } catch (e) {
      await _updateState(error: 'An error occurred: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await _updateState(loading: true);
      final response = await ApiLogout.logout();
      if (response.success) {
        user = null;
        await UserSecureStorage.clearAll();
        await _updateState();
        return true;
      }
      await _updateState(error: response.message ?? 'Logout failed.');
      return false;
    } catch (e) {
      await _updateState(error: 'An error occurred.');
      return false;
    }
  }

  Future<bool> refreshToken() async {
    final success = await _tokenService.refreshToken();
    if (success) notifyListeners();
    return success;
  }
}