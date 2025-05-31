import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiRegister {
  static const String baseUrl = 'http://localhost:5000';
  static Future<String?> register(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'];
    } else {
      print('register failed: ${response.statusCode} - ${response.body}');
      return null;
    }
  }
}
