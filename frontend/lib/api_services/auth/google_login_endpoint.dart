// api_services/google_login_endpoint.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_client.dart';
import 'package:frontend/api_services/client/api_reponse.dart';

class ApiLoginWithGoogle {
  static Future<ApiResponse<Map<String, dynamic>>> googleLoginEndPoint(
    String googleId,
    String email,
    String fullName,
    String avatar,
  ) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/auth/google-login-endpoint');
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
            'accessToken': data['accessToken'],
            'refreshToken': data['refreshToken'],
            'user': data['user'],
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
}