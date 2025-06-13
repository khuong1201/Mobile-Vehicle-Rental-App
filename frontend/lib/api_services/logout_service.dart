import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/api_services/api_reponse.dart';

class ApiLogout {
  static final _storage = FlutterSecureStorage();

  static Future<ApiResponse<String>> logout() async {
    try {
      await _storage.delete(key: 'accessToken');
      await _storage.delete(key: 'refreshToken');
      await _storage.delete(key: 'userID');

      return ApiResponse(success: true, message: 'Successfully logged out');
    } catch (e) {
      return ApiResponse(success: false, message: 'Error when logging out: $e');
    }
  }
}
