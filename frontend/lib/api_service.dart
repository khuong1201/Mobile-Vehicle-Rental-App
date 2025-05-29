import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000'; // IP backend thật khi chạy trên thiết bị

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
