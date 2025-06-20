import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

Future<ApiResponse<dynamic>> updatePersonalInfoApi<T extends ChangeNotifier>({
  required T viewModel,
  required AuthService authService,
  required String fullName,
  required String dateOfBirth,
  required String phoneNumber,
  required String gender,
  required List<String> IDs,
}) async {
  final response = await callProtectedApi(
    viewModel,
    authService: authService,
    endpoint: '/api/users/update-personal-info',
    method: 'PUT',
    body: {
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'IDs': IDs,
    },
  );

  return ApiResponse(
    success: response.success,
    data: response.data,
    message: response.message ?? (response.success
        ? 'Cập nhật thông tin cá nhân thành công'
        : 'Cập nhật thất bại'),
  );
}
