import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiChangePassword {
  static Future<ApiResponse<void>> changePassword<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await callProtectedApi<T>(
        viewModel,
        endpoint: '/api/auth/change-password',
        method: 'POST',
        authService: authService,
        body: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      return ApiResponse(
        success: response.success,
        message: response.message ?? (response.success
            ? 'Đổi mật khẩu thành công'
            : 'Đổi mật khẩu thất bại'),
      );
    } catch (e, stackTrace) {
      debugPrint('🔥 Lỗi khi đổi mật khẩu: $e\n$stackTrace');
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }
}
