import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/auth/auth_viewmodel.dart';
import 'package:frontend/viewmodels/auth/google_auth_viewmodel.dart';
import 'package:provider/provider.dart';
import '../user/user_secure_storage.dart';

class AuthService {
  final BuildContext context;

  AuthService(this.context);

  Future<String?> getAccessToken() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final gAuthViewModel = Provider.of<GAuthViewModel>(context, listen: false);
    

    if (await authViewModel.isLoggedIn()) {
      return await UserSecureStorage.getAccessToken();
    } else if (await gAuthViewModel.isLoggedIn()) {
      return await UserSecureStorage.getAccessToken();
    }
    return null;
  }
  Future<bool> checkRoleOwner() async {
    final userRole = await UserSecureStorage.getUserRole();
    if (userRole == null) return false;
    return userRole.toLowerCase() == 'owner';
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
        return await authViewModel.logout();
      } else if (await gAuthViewModel.isLoggedIn()) {
        await gAuthViewModel.signOut();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}