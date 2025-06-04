import 'package:flutter/material.dart';
import 'package:frontend/api_services/login_service.dart';
import 'package:frontend/api_services/logout_service.dart';
import 'package:frontend/api_services/register_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/models/user.dart';

class GAuthViewModel extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  String? token;
  User? _user;
  User? get user => _user;

  String? errorMessage;
  bool _isSigningIn = false;
  bool get isSigningIn => _isSigningIn;

  Future<bool> signInWithGoogle() async {
    _isSigningIn = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        _user = User.fromGoogleAccount(account);

        final response = await ApiLogin.login(account.email, account.id);

        if (response.success && response.data != null) {
          debugPrint('Đăng nhập Google thành công: ${response.message}');
          token = response.data;
          notifyListeners();
          return true;
        } else {
          debugPrint('Đăng nhập Google thất bại: ${response.message}');
          errorMessage = response.message ?? 'Đăng nhâp thất bại.';
          notifyListeners();
          return false;
        } 
      }
    } catch (e) {
      debugPrint('Lỗi đăng nhập Google: $e');
      errorMessage = 'Đã xảy ra lỗi: $e';
    } finally {
      _isSigningIn = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> registerWithGoogle() async {
    _isSigningIn = true;
    errorMessage = null;
    notifyListeners();

    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        _user = User.fromGoogleAccount(account);

        final response = await ApiRegister.register(account.email, account.id, account.displayName ?? '');

        if (response.success) {
          debugPrint('Đăng ký Google thành công: ${response.message}');
          notifyListeners();
          return true;
        } else {
          debugPrint('Đăng ký Google thất bại: ${response.message}');
          errorMessage = response.message ?? 'Đăng ký thất bại.';
          notifyListeners();
          return false;
        }
      }
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('Lỗi đăng ký Google: $e');
      errorMessage = 'Đã xảy ra lỗi: $e';
      notifyListeners();
      return false;
    } finally {
      _isSigningIn = false;
      notifyListeners();
    }
  }

  Future<bool> signOut(String accessToken, String userID) async {
  try {
    final response = await ApiLogout.logout(accessToken, userID);
    if (response.success) {
      token = null;
      _user = null;
      notifyListeners();
      return true;
    } else {
      errorMessage = response.message ?? 'Đăng xuất thất bại.';
      notifyListeners();
      return false;
    }
  } catch (e) {
    errorMessage = 'Đã xảy ra lỗi: $e';
    notifyListeners();
    return false;
  }
}
}
