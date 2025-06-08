import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/api_services/api_client.dart';
import 'package:frontend/api_services/api_reponse.dart';

class ApiVerifyOTP {
  static Future<ApiResponse<String>> verifyOTP(String email, String otp) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/auth/verify');
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
}