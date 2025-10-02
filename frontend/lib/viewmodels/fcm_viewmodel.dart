import 'dart:io';
import 'package:flutter/material.dart';
import '../api_services/fcm_api.dart';
import '../api_services/fcm_services.dart';
import '../viewmodels/user/user_secure_storage.dart';

class FCMViewModel extends ChangeNotifier {
  String? _token;
  String? _deviceId;
  String? get token => _token;

  Future<void> initFCM({String? userId, String? authToken}) async {
    debugPrint('🚀 Khởi tạo FCM...');

    await FCMService.instance.requestPermission();

    _deviceId = await FCMService.instance.getDeviceId();
    _token = await FCMService.instance.getToken();

    debugPrint('📱 Device ID: $_deviceId');
    debugPrint('🔑 FCM Token: $_token');
    notifyListeners();

    if (userId != null && _token != null) {
      await _sendTokenToServer(userId: userId, authToken: authToken);
    }

    FCMService.instance.onTokenRefresh.listen((newToken) async {
      _token = newToken;
      notifyListeners();

      final savedUserId = userId ?? await UserSecureStorage.getUserId();
      final savedAuthToken = authToken ?? await UserSecureStorage.getAccessToken();

      debugPrint('♻️ Token FCM được làm mới: $newToken');
      if (savedUserId != null) {
        await _sendTokenToServer(userId: savedUserId, authToken: savedAuthToken);
      }
    });
  }

  Future<void> _sendTokenToServer({required String userId, String? authToken}) async {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    final success = await FCMApi.registerToken(
      token: _token!,
      userId: userId,
      authToken: authToken,
      platform: platform,
      deviceId: _deviceId ?? 'unknown',
    );
    debugPrint(success
        ? '✅ Đã gửi token lên server thành công cho user: $userId'
        : '❌ Gửi token thất bại!');
  }

  Future<void> removeToken({required String userId, String? authToken}) async {
    if (_token == null) return;

    final success = await FCMApi.removeToken(token: _token!, userId: userId, authToken: authToken);

    if (success) debugPrint('🗑️ Token đã bị xóa khỏi server.');
    _token = null;
    notifyListeners();

    await FCMService.instance.deleteToken();
  }

  Future<void> loadSavedToken() async {
    _token = await FCMService.instance.getSavedToken();
    debugPrint('💾 Token load từ local: $_token');
    notifyListeners();
  }
}