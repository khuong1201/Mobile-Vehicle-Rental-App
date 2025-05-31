import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiLogin {
  static const String baseUrl = 'http://localhost:5000';
  static Future<String?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password})
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['accessToken'];
    } else {
      print('Login failed: ${response.statusCode} - ${response.body}');
      return null;
    }
  }
}
