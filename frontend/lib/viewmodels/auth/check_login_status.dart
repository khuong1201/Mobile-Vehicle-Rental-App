import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
import 'package:frontend/viewmodels/user/user_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

Future<void> checkLoginStatus(BuildContext context) async {

  // Hiện loading khi kiểm tra login
  if (!context.mounted) return;
  if (context.mounted) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  try {
    final prefs = await SharedPreferences.getInstance();

    // Kiểm tra lần đầu mở app
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    debugPrint('isFirstLaunch: $isFirstLaunch'); 

    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
      if (context.mounted) {
        Navigator.pop(context); 
        Navigator.pushReplacementNamed(context, '/welcome');
      }
      return;
    }

    // Kiểm tra trạng thái Remember Me
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    debugPrint('RememberMe: $rememberMe');

    if (!rememberMe) {
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }


    // Kiểm tra token + user
    if (!context.mounted) return;
    final authService = Provider.of<AuthService>(context, listen: false);
    final accessToken = await UserSecureStorage.getAccessToken();
    final user = await UserSecureStorage.getUser();

    debugPrint('AccessToken: $accessToken, User: $user'); 

    if (accessToken == null || user == null) {
      if (context.mounted) {
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No session found, please log in')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }

    // Thử refresh token nếu rememberMe bật
    final refreshSuccess = await authService.refreshToken().timeout(const Duration(seconds: 10));
    
    if (refreshSuccess) {
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      await UserSecureStorage.clearAll();
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired, please log in again')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  } catch (e) {
    await UserSecureStorage.clearAll();
    if (context.mounted) {
      Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error checking login status, please log in again')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}