import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiRegister {
  static const String baseUrl = 'http://10.0.2.2:5000';
  static Future<dynamic> register(
    email,
    password,
    name,
  ) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'fullName': name }),
    );

    try {
      final data = jsonDecode(response.body);
      return data; 
    } catch (e) {
      debugPrint('JSON decode error: $e');
      return {'message': 'Unexpected error occurred', 'success': false};
    }
  }
}
