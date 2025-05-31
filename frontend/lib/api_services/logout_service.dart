import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiLogout {
  static const String baseUrl = 'http://localhost:5000';
  static Future<String?> logout(String accessToken, String userID) async {
    final url = Uri.parse('$baseUrl/api/auth/logout');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'accessToken': accessToken, 'userID': userID}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'];
    } else {
      print('Logout failed: ${response.statusCode} - ${response.body}');
      return null;
    }
  }
}
