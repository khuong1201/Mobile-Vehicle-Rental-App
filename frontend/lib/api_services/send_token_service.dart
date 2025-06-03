import 'package:http/http.dart' as http;

class SendTokenBackend {
  static const String baseUrl = 'http://localhost:5000'; 
  static Future<String?> sendTokenToBackend(String jwtToken) async {
    final url = Uri.parse('$baseUrl/api/auth/verify');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $jwtToken'},
    );

    if (response.statusCode == 200) {
      return jwtToken;
    } else {
      return null;
    }
  }
}
