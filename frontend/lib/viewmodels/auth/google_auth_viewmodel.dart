import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:frontend/api_services/auth/google_login_endpoint.dart';
import 'package:frontend/api_services/auth/token_service.dart';
import '/models/user.dart';
import '../user/user_secure_storage.dart';

class GAuthViewModel extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final TokenService _tokenService = TokenService();
  User? user;

  Future<bool> isLoggedIn() async {
    final accessToken = await UserSecureStorage.getAccessToken();
    final user = await UserSecureStorage.getUser();
    return accessToken != null && user != null;
  }

  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final response = await ApiLoginWithGoogle.googleLoginEndPoint(
        googleUser.id,
        googleUser.email,
        googleUser.displayName ?? 'User',
        googleUser.photoUrl ?? 'assets/images/user/default_avatar.png',
      );
      debugPrint(
        "👉 Kết quả đăng nhập Google: ${response.success}, ${response.message}",
      );
      if (response.success && response.data != null) {
        final accessToken = response.data!['accessToken'] as String?;
        final refreshToken = response.data!['refreshToken'] as String?;
        final userData = response.data!['user'] as Map<String, dynamic>?;

        if (accessToken == null || refreshToken == null || userData == null) {
          return null;
        }

        user = User.fromJson(userData);
        await UserSecureStorage.saveUser(user!);
        debugPrint(
          '🧪 User loaded from secure storage: ${jsonEncode(user?.toJson())}',
        );
        debugPrint('🧪 User ID: ${user?.id}');
        await UserSecureStorage.saveAccessToken(accessToken);
        await UserSecureStorage.saveRefreshToken(refreshToken);
        notifyListeners();
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> refreshToken() async {
    final success = await _tokenService.refreshToken();
    if (success) notifyListeners();
    return success;
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      await UserSecureStorage.clearAll();
      user = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Đã xảy ra lỗi khi đăng xuất: $e');
    }
  }
}
