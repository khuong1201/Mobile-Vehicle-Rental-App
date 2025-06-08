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

  Future<bool> verifyOTP(String email, String otp) async {
    try {
      isLoading = true;
      errorMessage = null;
      isOTPVerified = false;
      notifyListeners();

      final response = await ApiVerifyOTP.verifyOTP(email, otp);
      if (response.success) {
        debugPrint('Xác minh OTP thành công: ${response.message}');
        isOTPVerified = true;
        notifyListeners();
        return true;
      } else {
        debugPrint('Xác minh OTP thất bại: ${response.message}');
        errorMessage = response.message ?? 'Xác minh OTP thất bại.';
        isOTPVerified = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Lỗi xác minh OTP: $e');
      errorMessage = 'Đã xảy ra lỗi: $e';
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

      final response = await ApiLogin.login(email, password);
      if (response.success && response.data != null) {
        final userData = response.data!['user'] as Map<String, dynamic>?;
        if (userData == null) {
          debugPrint('Invalid login response: missing user data');
          errorMessage = 'Dữ liệu người dùng không hợp lệ';
          notifyListeners();
          return false;
        }

        user = User.fromJson(userData);
        debugPrint('Đăng nhập thành công: ${user!.email}');
        notifyListeners();
        return true;
      } else {
        debugPrint('Đăng nhập thất bại: ${response.message}');
        errorMessage = response.message ?? 'Đăng nhập sai thông tin.';
        notifyListeners();
        return false;
      }
    } catch (err, stackTrace) {
      debugPrint('Login error: $err\n$stackTrace');
      errorMessage = 'Đã xảy ra lỗi: $err';
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
      if (response.success) {
        debugPrint('Đăng ký thành công: ${response.message}');
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
        debugPrint('Đăng ký thất bại: ${response.message}');
        errorMessage = response.message ?? 'Đăng ký thất bại.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Lỗi đăng ký: $e');
      errorMessage = 'Đã xảy ra lỗi: $e';
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
      if (response.success) {
        debugPrint('Đăng xuất thành công: ${response.message}');
        user = null;
        await _secureStorage.delete(key: 'accessToken');
        await _secureStorage.delete(key: 'refreshToken');
        await _secureStorage.delete(key: 'user');
        notifyListeners();
        return true;
      } else {
        debugPrint('Đăng xuất thất bại: ${response.message}');
        errorMessage = response.message ?? 'Đăng xuất thất bại.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Lỗi đăng xuất: $e');
      errorMessage = '';
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}