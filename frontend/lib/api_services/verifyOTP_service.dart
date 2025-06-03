import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiVerifyOTP {
  static const String baseUrl = 'http://10.0.2.2:5000';

  static Future<String?> register(String email, String otp) async {
    final url = Uri.parse('$baseUrl/api/auth/verify');

    debugPrint('🔹 Sending POST request to: $url');
    debugPrint('🔹 Request body: {email: $email, otp: $otp}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      debugPrint('🔹 Response status: ${response.statusCode}');
      debugPrint('🔹 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('✅ Register success: ${data['message']}');
        return data['message'];
      } else {
        debugPrint('❌ Register failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('🔥 Exception during register: $e');
      return null;
    }
  }
}
