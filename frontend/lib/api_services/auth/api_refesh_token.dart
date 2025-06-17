import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/api_services/client/api_client.dart';
import 'package:frontend/api_services/client/api_reponse.dart';

class ApiRefresh {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<ApiResponse<bool>> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refreshToken');
      if (refreshToken == null) {
        debugPrint('No refreshToken found');
        return ApiResponse(success: false, message: 'No refresh token available');
      }

      final url = Uri.parse('${ApiClient.baseUrl}/api/auth/refresh-token');
      final response = await ApiClient().client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;

        if (newAccessToken == null || newRefreshToken == null) {
          debugPrint('Invalid refresh response: missing accessToken or refreshToken');
          return ApiResponse(
            success: false,
            message: 'Invalid refresh response',
          );
        }

        await _secureStorage.write(key: 'accessToken', value: newAccessToken);
        await _secureStorage.write(key: 'refreshToken', value: newRefreshToken);
        debugPrint('Token refreshed successfully');
        return ApiResponse(
          success: true,
          data: true,
          message: 'Token refreshed successfully',
        );
      } else {
        debugPrint('Token refresh failed: ${response.statusCode} - ${response.body}');
        return ApiResponse(
          success: false,
          message: 'Token refresh failed: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Refresh token error: $e\n$stackTrace');
      return ApiResponse(success: false, message: 'Error: $e');
    }
  }
}