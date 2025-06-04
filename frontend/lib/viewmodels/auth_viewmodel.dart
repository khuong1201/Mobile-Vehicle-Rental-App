import 'package:flutter/material.dart';
import 'package:frontend/api_services/login_service.dart';
import 'package:frontend/api_services/logout_service.dart';
import 'package:frontend/api_services/register_service.dart';
import 'package:frontend/api_services/verifyOTP_service.dart';

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
        debugPrint('Đăng nhập thành công, token: ${response.data}');
        token = response.data;
        this.email = email;
        notifyListeners();
        return true;
      } else {
        debugPrint('Đăng nhập thất bại: ${response.message}');
        errorMessage = response.message ?? 'Đăng nhập thất bại.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Lỗi đăng nhập: $e');
      errorMessage = 'Đã xảy ra lỗi: $e';
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
        this.email = email;
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
        token = null;
        email = null;
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
      errorMessage = 'Đã xảy ra lỗi: $e';
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}