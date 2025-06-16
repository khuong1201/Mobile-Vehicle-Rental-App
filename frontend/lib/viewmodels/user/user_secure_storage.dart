import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '/models/user.dart';

class UserSecureStorage {
  static const _userKey = 'user';
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static final _storage = FlutterSecureStorage();

  static Future<void> saveUser(User user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final jsonString = await _storage.read(key: _userKey);
    if (jsonString == null) return null;
    try {
      return User.fromJson(jsonDecode(jsonString));
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  static Future<void> clearAll() async {
    await Future.wait([
      _storage.delete(key: _userKey),
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
}