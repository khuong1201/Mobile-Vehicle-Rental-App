import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/api_services/api_client.dart';
import 'package:frontend/api_services/api_reponse.dart';

class ApiLogout {
  static Future<ApiResponse<String>> logout(String accessToken, String userID) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/auth/logout');
    try {
      final response = await ApiClient().client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'accessToken': accessToken, 'userID': userID}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiResponse(success: true, message: data['message']);
      } else {
        return ApiResponse(
          success: false,
          message: 'Đăng xuất thất bại: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('🔥 Lỗi trong quá trình đăng xuất: $e');
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }
}
