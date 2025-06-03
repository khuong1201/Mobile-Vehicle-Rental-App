import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiRegister {
  static const String baseUrl = 'http://10.0.2.2:5000';
  static Future<String?> register(
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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'];
    } else {
      print('register failed: ${response.statusCode} - ${response.body}');
      return null;
    }
  }
}
