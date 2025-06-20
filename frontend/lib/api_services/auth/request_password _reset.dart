import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_client.dart';
import 'package:frontend/api_services/client/api_reponse.dart';

class ApiPasswordReset {
  /// Gửi OTP về email để đặt lại mật khẩu
  static Future<ApiResponse<void>> requestPasswordReset(String email) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/auth/request-password-reset');

    try {
      final response = await ApiClient().client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse(success: true, message: data['message']);
      } else {
        return ApiResponse(success: false, message: data['message'] ?? 'Gửi OTP thất bại');
      }
    } catch (e) {
      debugPrint('🔥 Lỗi gửi OTP: $e');
      return ApiResponse(success: false, message: 'Lỗi khi gửi OTP: $e');
    }
  }

  static Future<ApiResponse<void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/auth/reset-password');

    try {
      final response = await ApiClient().client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse(success: true, message: data['message']);
      } else {
        return ApiResponse(success: false, message: data['message'] ?? 'Reset thất bại');
      }
    } catch (e) {
      debugPrint('🔥 Lỗi reset mật khẩu: $e');
      return ApiResponse(success: false, message: 'Lỗi khi reset mật khẩu: $e');
    }
  }
}
