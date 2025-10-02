import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/api_services/client/api_client.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/models/user.dart';

class AuthApi {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static final _storage = FlutterSecureStorage();

  static Future<ApiResponse<Map<String, dynamic>>> register(
      String email, String password, String name) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/auth/register');
    try {
      final response = await ApiClient().client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'fullName': name}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse(success: true, data: data, message: data['message']);
      } else {
        final data = jsonDecode(response.body);
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'Đăng ký thất bại: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('🔥 Lỗi trong quá trình đăng ký: $e');
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }

  static Future<ApiResponse<Map<String, dynamic>>> login(String email, String password) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/auth/login');
    try {
      // Validate input
      if (email.isEmpty || password.isEmpty) {
        debugPrint('Email or password is empty');
        return ApiResponse(success: false, message: 'Vui lòng nhập email và mật khẩu');
      }

      final response = await ApiClient().client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final responseData = data['data'] as Map<String, dynamic>?;

        final accessToken = responseData?['accessToken'] as String?;
        final userData = responseData?['data'] as Map<String, dynamic>?;

        if (accessToken == null || userData == null) {
          debugPrint('Invalid login response: missing accessToken or user');
          return ApiResponse(success: false, message: 'The returned data is invalid');
        }

        final user = User.fromJson(userData);

        await _secureStorage.write(key: 'accessToken', value: accessToken);
        await _secureStorage.write(key: 'user', value: jsonEncode(user.toJson()));

        debugPrint('Login successful: ${user.email}');
        return ApiResponse(
          success: true,
          data: {
            'accessToken': accessToken,
            'user': userData,
          },
          message: data['message'] ?? 'Log in successfully',
        );
      } else {
        debugPrint('Login failed: ${response.statusCode} - ${response.body}');
        final data = jsonDecode(response.body);
        return ApiResponse(
          success: false,
          message: data['message'] ?? 'Log in failed',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Login error: $e\n$stackTrace');
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }
  
  static Future<ApiResponse<Map<String, dynamic>>> googleLogin(
    String googleId,
    String email,
    String fullName,
    String avatar,
  ) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/auth/google-login');
    try {
      final response = await ApiClient().client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'googleId': googleId,
          'email': email,
          'fullName': fullName,
          'avatar': avatar,
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse(
          success: data['success'] ?? true,
          data: {
            'accessToken': data?['accessToken'],
            'user': data?['user'],
          },
          message: data['message'] ?? 'Đăng nhập thành công',
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'Đăng nhập thất bại: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('🔥 Lỗi trong quá trình đăng nhập: $e');
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }

  static Future<ApiResponse<bool>> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refreshToken');
      if (refreshToken == null) {
        debugPrint('No refreshToken found');
        return ApiResponse(success: false, message: 'No refresh token available');
      }

      final url = Uri.parse('${ApiClient.baseUrl}/api/auth/refresh-token');
      final response = await ApiClient().client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;

        if (newAccessToken == null || newRefreshToken == null) {
          debugPrint('Invalid refresh response: missing accessToken or refreshToken');
          return ApiResponse(
            success: false,
            message: 'Invalid refresh response',
          );
        }

        await _secureStorage.write(key: 'accessToken', value: newAccessToken);
        await _secureStorage.write(key: 'refreshToken', value: newRefreshToken);
        debugPrint('Token refreshed successfully');
        return ApiResponse(
          success: true,
          data: true,
          message: 'Token refreshed successfully',
        );
      } else {
        debugPrint('Token refresh failed: ${response.statusCode} - ${response.body}');
        return ApiResponse(
          success: false,
          message: 'Token refresh failed: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Refresh token error: $e\n$stackTrace');
      return ApiResponse(success: false, message: 'Error: $e');
    }
  }

  static Future<ApiResponse<String>> verifyOTP(String email, String otp) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/auth/verify-otp');
    debugPrint('🔹 Gửi yêu cầu POST tới: $url');
    debugPrint('🔹 Nội dung yêu cầu: {email: $email, otp: $otp}');

    try {
      final response = await ApiClient().client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      ).timeout(const Duration(seconds: 10));

      debugPrint('🔹 Trạng thái phản hồi: ${response.statusCode}');
      debugPrint('🔹 Nội dung phản hồi: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse(success: true, data: data['message']);
      } else {
        return ApiResponse(
          success: false,
          message: 'Xác minh OTP thất bại: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('🔥 Lỗi trong quá trình xác minh OTP: $e');
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }

  static Future<ApiResponse<String>> logout() async {
  try {
    final token = await _storage.read(key: 'accessToken');
    final url = Uri.parse('${ApiClient.baseUrl}/api/auth/logout');

    await ApiClient().client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Xóa local storage sau khi backend logout
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    await _storage.delete(key: 'userID');

    return ApiResponse(success: true, message: 'Successfully logged out');
  } catch (e) {
    return ApiResponse(success: false, message: 'Error when logging out: $e');
  }
}


}

class TokenService {
  Future<bool> refreshToken() async {
    final response = await AuthApi.refreshToken();
    if (response.success) {
      debugPrint('TokenService: Refresh token successful');
      return true;
    } else {
      debugPrint('TokenService: Refresh token failed - ${response.message}');
      return false;
    }
  }
}