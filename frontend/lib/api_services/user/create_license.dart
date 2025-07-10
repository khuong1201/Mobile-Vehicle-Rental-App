import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

Future<ApiResponse<dynamic>> createDriverLicenseApi<T extends ChangeNotifier>({
  required T viewModel,
  required AuthService authService,
  required String typeOfDriverLicense,
  required String classLicense,
  required String licenseNumber,
  required File frontImage,
  required File backImage,
}) async {
  final response = await callProtectedApi(
    viewModel,
    authService: authService,
    endpoint: '/api/user/create-license',
    method: 'POST',
    isMultipart: true,
    fields: {
      'typeOfDriverLicense': typeOfDriverLicense,
      'classLicense': classLicense,
      'licenseNumber': licenseNumber,
    },
    files: {
      'driverLicenseFront': [frontImage],
      'driverLicenseBack': [backImage],
    },
  );

  return ApiResponse(
    success: response.success,
    data: response.data,
    message: response.message ??
        (response.success ? 'Tạo giấy phép lái xe thành công' : 'Tạo giấy phép thất bại'),
  );
}
