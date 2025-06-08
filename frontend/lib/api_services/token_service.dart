import 'package:flutter/material.dart';
import 'package:frontend/api_services/api_refesh_token.dart';


class TokenService {
  Future<bool> refreshToken() async {
    final response = await ApiRefresh.refreshToken();
    if (response.success) {
      debugPrint('TokenService: Refresh token successful');
      return true;
    } else {
      debugPrint('TokenService: Refresh token failed - ${response.message}');
      return false;
    }
  }
}