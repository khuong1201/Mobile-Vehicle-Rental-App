import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FCMService {
  FCMService._();
  static final FCMService instance = FCMService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final _tokenStream = StreamController<String>.broadcast();
  Stream<String> get onTokenRefresh => _tokenStream.stream;

  static const _tokenKey = 'fcm_token';
  static const _deviceIdKey = 'device_id';

  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission(alert: true, badge: true, sound: true);
    debugPrint('🔔 FCM permission: ${settings.authorizationStatus}');
  }

  Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_deviceIdKey);
    if (saved != null) return saved;

    final deviceInfo = DeviceInfoPlugin();
    String deviceId;

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      deviceId = info.id;
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      deviceId = info.identifierForVendor ?? 'unknown_ios';
    } else {
      deviceId = 'unknown_device';
    }

    await prefs.setString(_deviceIdKey, deviceId);
    return deviceId;
  }

  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) await _saveToken(token);

      _messaging.onTokenRefresh.listen((newToken) async {
        await _saveToken(newToken);
        _tokenStream.add(newToken);
      });

      return token;
    } catch (e) {
      debugPrint('❌ Error getting FCM token: $e');
      return null;
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      debugPrint('🗑️ Token deleted locally and from Firebase');
    } catch (e) {
      debugPrint('❌ Error deleting token: $e');
    }
  }

  void dispose() => _tokenStream.close();
}