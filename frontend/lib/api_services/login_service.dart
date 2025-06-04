import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/api_services/api_client.dart';
import 'package:frontend/api_services/api_reponse.dart';

class ApiLogin {
  static Future<ApiResponse<String>> login(String email, String password) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/auth/login');
    try {
      final response = await ApiClient().client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse(
          success: data['success'] ?? true,
          data: data['token'],
          message: data['message'],
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
