import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/api_services/api_client.dart';
import 'package:frontend/api_services/api_reponse.dart';
import '/models/user.dart';

class ApiLogin {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

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
        final accessToken = data['accessToken'] as String?;
        final refreshToken = data['refreshToken'] as String?;
        final userData = data['user'] as Map<String, dynamic>?;

        if (accessToken == null || refreshToken == null || userData == null) {
          debugPrint('Invalid login response: missing accessToken, refreshToken, or user');
          return ApiResponse(success: false, message: 'The returned data is invalid');
        }

        // Convert userData to User object
        final user = User.fromJson(userData);

        // Save to secure storage
        await _secureStorage.write(key: 'accessToken', value: accessToken);
        await _secureStorage.write(key: 'refreshToken', value: refreshToken);
        await _secureStorage.write(key: 'user', value: jsonEncode(user.toJson()));

        debugPrint('Login successful: ${user.email}');
        return ApiResponse(
          success: true,
          data: {
            'accessToken': accessToken,
            'refreshToken': refreshToken,
            'user': userData,
          },
          message: data['message'] ?? 'Log in successfully',
        );
      } else {
        debugPrint('Login failed: ${response.statusCode} - ${response.body}');
        return ApiResponse(
          success: false,
          message: 'Đăng nhập thất bại: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Login error: $e\n$stackTrace');
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }
}