import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/viewmodels/auth/auth_viewmodel.dart';
import 'package:frontend/viewmodels/auth/google_auth_viewmodel.dart';
import 'package:frontend/viewmodels/user/user_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final BuildContext context;

  User? _user;
  User? get user => _user;

  AuthService(this.context);

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<String?> getUserIdFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
  
  Future<void> loadUser() async {
    final storedUser = await UserSecureStorage.getUser();
    _user = storedUser;
    notifyListeners();
  }

  Future<String?> getAccessToken() async {
    return await UserSecureStorage.getAccessToken();
  }

  Future<String?> getUserId() async {
    return _user?.userId ?? await UserSecureStorage.getUserId();
  }

  Future<bool> checkRoleOwner() async {
    final userRole = await UserSecureStorage.getUserRole();
    return userRole == 'owner';
  }

  Future<bool> refreshToken() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final gAuthViewModel = Provider.of<GAuthViewModel>(context, listen: false);

    if (await authViewModel.isLoggedIn()) {
      return await authViewModel.refreshToken();
    } else if (await gAuthViewModel.isLoggedIn()) {
      return await gAuthViewModel.refreshToken();
    }
    return false;
  }

  Future<bool> logout() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final gAuthViewModel = Provider.of<GAuthViewModel>(context, listen: false);

    try {
      if (await authViewModel.isLoggedIn()) {
        await authViewModel.logout();
      } else if (await gAuthViewModel.isLoggedIn()) {
        await gAuthViewModel.signOut();
      }
      clearUser();
      return true;
    } catch (e) {
      return false;
    }
  }
}