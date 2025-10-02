import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/api_services/auth/auth_api.dart';
import 'package:frontend/viewmodels/fcm_viewmodel.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/user.dart';
import '../user/user_secure_storage.dart';

class GAuthViewModel extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final TokenService _tokenService = TokenService();
  final FCMViewModel _fcmViewModel = FCMViewModel();
  User? user;

  Future<bool> isLoggedIn() async {
    final accessToken = await UserSecureStorage.getAccessToken();
    final storeUser = await UserSecureStorage.getUser();
    return accessToken != null && storeUser != null;
  }

  Future<User?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final response = await AuthApi.googleLogin(
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
        final userData = response.data!['user'] as Map<String, dynamic>?;

        if (accessToken == null || userData == null) {
          return null;
        }

        user = User.fromJson(userData);
        await UserSecureStorage.saveUser(user!);
        debugPrint(
          '🧪 User loaded from secure storage: ${jsonEncode(user?.toJson())}',
        );
        debugPrint('🧪 User ID: ${user?.id}');
        await UserSecureStorage.saveAccessToken(accessToken);
        await _fcmViewModel.initFCM(
          userId: user!.id,
          authToken: accessToken,
        );
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
      final userId = user?.id ?? await UserSecureStorage.getUserId();
      final authToken = await UserSecureStorage.getAccessToken();

      if (userId != null) {
        await _fcmViewModel.removeToken(
          userId: userId,
          authToken: authToken,
        );
      }
      await UserSecureStorage.clearAll();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('rememberMe', false);

      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
      
      user = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Đã xảy ra lỗi khi đăng xuất: $e');
    }
  }
}
