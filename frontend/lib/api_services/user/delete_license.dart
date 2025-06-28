import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

Future<ApiResponse<dynamic>> deleteDriverLicenseApi<T extends ChangeNotifier>({
  required T viewModel,
  required AuthService authService,
  required String licenseId,
}) async {
  final response = await callProtectedApi(
    viewModel,
    authService: authService,
    endpoint: '/api/user/delete-license',
    method: 'DELETE',
    body: {
      'licenseId': licenseId,
    },
  );

  return ApiResponse(
    success: response.success,
    data: response.data,
    message: response.message ?? (response.success
        ? 'Xoá giấy phép thành công'
        : 'Xoá giấy phép thất bại'),
  );
}

