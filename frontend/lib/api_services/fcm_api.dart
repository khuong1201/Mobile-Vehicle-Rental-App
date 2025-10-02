import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/api_services/client/api_client.dart';

class FCMApi {
  static Future<bool> registerToken({
    required String token,
    required String userId,
    required String platform,
    required String deviceId,
    String? authToken,
  }) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/device-token/register');

    try {
      debugPrint('📤 [FCM] Sending token to server...');
      debugPrint('🔑 userId: $userId');
      debugPrint('📱 platform: $platform | deviceId: $deviceId');
      debugPrint('🎯 token: $token');
      debugPrint('🧾 Authorization: ${authToken != null ? 'Bearer ${authToken.substring(0, 10)}...' : '❌ NONE'}');

      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null && authToken.isNotEmpty)
            'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'token': token,
          'platform': platform,
          'deviceId': deviceId,
          'userId': userId,
        }),
      );

      debugPrint('📩 Server responded: ${res.statusCode}');
      debugPrint('📨 Body: ${res.body}');

      // Một số backend trả 201 hoặc 204 thay vì 200
      if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204) {
        debugPrint('✅ FCM token registered successfully');
        return true;
      } else {
        debugPrint('❌ FCM token register failed: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('🔥 [FCM] Register token error: $e');
      return false;
    }
  }

  static Future<bool> removeToken({
    required String token,
    required String userId,
    String? authToken,
  }) async {
    final url = Uri.parse('${ApiClient.baseUrl}/api/fcm/remove');
    try {
      debugPrint('🗑 [FCM] Removing token for userId=$userId');
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (authToken != null && authToken.isNotEmpty)
            'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'token': token,
          'userId': userId,
        }),
      );

      debugPrint('📩 Remove response: ${res.statusCode} | ${res.body}');

      return res.statusCode == 200 || res.statusCode == 204;
    } catch (e) {
      debugPrint('🔥 [FCM] Remove token error: $e');
      return false;
    }
  }
}