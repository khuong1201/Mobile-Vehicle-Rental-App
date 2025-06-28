import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

Future<ApiResponse<dynamic>> getUserProfileApi<T extends ChangeNotifier>({
  required T viewModel,
  required AuthService authService,
}) async {
  final response = await callProtectedApi(
    viewModel,
    authService: authService,
    endpoint: '/api/user/get-user-profile',
    method: 'GET',
  );

  return ApiResponse(
    success: response.success,
    data: response.data?['user'], 
    message: response.message ?? (response.success
        ? 'Lấy thông tin người dùng thành công'
        : 'Lấy thông tin thất bại'),
  );
}
