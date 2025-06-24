import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

Future<ApiResponse<dynamic>> updateUserRoleApi<T extends ChangeNotifier>({
  required T viewModel,
  required AuthService authService,
  required String userId,
  required String newRole,
}) async {
  final response = await callProtectedApi(
    viewModel,
    authService: authService,
    endpoint: '/api/users/update-role',
    method: 'PUT',
    body: {
      'userId': userId,
      'newRole': newRole,
    },
  );

  return ApiResponse(
    success: response.success,
    data: response.data,
    message: response.message ??
        (response.success
            ? 'Cập nhật vai trò thành công'
            : 'Cập nhật vai trò thất bại'),
  );
}
