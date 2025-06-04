import 'package:frontend/api_services/api_client.dart';
import 'package:frontend/api_services/api_reponse.dart';
import 'package:http/http.dart' as http;

class SendTokenBackend {
  static Future<ApiResponse<String>> sendTokenToBackend(String jwtToken) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/auth/verify');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $jwtToken'},
    );
    if (response.statusCode == 200) {
      return ApiResponse(success: true, data: 'Token sent successfully');
    } else {
      return ApiResponse(
        success: false,
        message: 'Failed to send token: ${response.statusCode}',
      );
    }
  }
}
