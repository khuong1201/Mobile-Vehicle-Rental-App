import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:frontend/api_services/google_login_endpoint.dart';
import 'package:frontend/api_services/token_service.dart';
import '/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GAuthViewModel extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final TokenService _tokenService = TokenService();
  User? user;


  // Check login status
  Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    final user = await getUser();
    return accessToken != null && user != null;
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('Google Sign-In cancelled by user');
        return null;
      }

      final response = await ApiLoginWithGoogle.googleLoginEndPoint(
        googleUser.id,
        googleUser.email,
        googleUser.displayName ?? '',
      );

      if (response.success && response.data != null) {
        final accessToken = response.data!['accessToken'] as String?;
        final refreshToken = response.data!['refreshToken'] as String?;
        final userData = response.data!['user'] as Map<String, dynamic>?;

        if (accessToken == null || refreshToken == null || userData == null) {
          debugPrint(
            'Invalid response data: missing accessToken, refreshToken, or user',
          );
          return null;
        }

        final user = User.fromJson(userData);
        this.user = user;

        await _secureStorage.write(key: 'accessToken', value: accessToken);
        await _secureStorage.write(key: 'refreshToken', value: refreshToken);
        await _secureStorage.write(
          key: 'user',
          value: jsonEncode(user.toJson()),
        );

        debugPrint('Google Sign-In successful: ${user.email}');
        notifyListeners();
        return user;
      } else {
        debugPrint('Backend authentication failed: ${response.message}');
        return null;
      }
    } catch (error, stackTrace) {
      debugPrint('Google Sign-In error: $error\n$stackTrace');
      return null;
    }
  }

  // Get accessToken
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: 'accessToken');
    } catch (e) {
      debugPrint('Error reading accessToken: $e');
      return null;
    }
  }

  // Get user data
  Future<User?> getUser() async {
    try {
      final userJson = await _secureStorage.read(key: 'user');
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      }
      return null;
    } catch (e) {
      debugPrint('Error reading user data: $e');
      return null;
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    final success = await _tokenService.refreshToken();
    if (success) {
      notifyListeners();
    }
    return success;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _secureStorage.delete(key: 'accessToken');
      await _secureStorage.delete(key: 'refreshToken');
      await _secureStorage.delete(key: 'user');
      debugPrint('Signed out successfully');
      notifyListeners();
    } catch (error, stackTrace) {
      debugPrint('Sign out error: $error\n$stackTrace');
    }
  }
}
