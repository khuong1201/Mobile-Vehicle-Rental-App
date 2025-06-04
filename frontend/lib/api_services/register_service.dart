import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/api_services/api_client.dart';
import 'package:frontend/api_services/api_reponse.dart';

class ApiRegister {
  static Future<ApiResponse<Map<String, dynamic>>> register(
      String email, String password, String name) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/auth/register');
    try {
      final response = await ApiClient().client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password, 'fullName': name}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
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
}
