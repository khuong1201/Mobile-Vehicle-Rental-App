import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

Future<ApiResponse<dynamic>> updateDriverLicenseApi<T extends ChangeNotifier>({
  required T viewModel,
  required AuthService authService,
  required String typeOfDriverLicense,
  required String classLicense,
  required String licenseNumber,
  File? frontImage,
  File? backImage,
}) async {
  final files = <String, List<File>>{};
  if (frontImage != null) files['driverLicenseFront'] = [frontImage];
  if (backImage != null) files['driverLicenseBack'] = [backImage];
  
  final response = await callProtectedApi(
    viewModel,
    authService: authService,
    endpoint: '/api/user/update-license',
    method: 'PUT',
    isMultipart: true,
    fields: {
      'typeOfDriverLicense': typeOfDriverLicense,
      'classLicense': classLicense,
      'licenseNumber': licenseNumber,
    },
    files: files.isNotEmpty ? files : null,
  );

  return ApiResponse(
    success: response.success,
    data: response.data,
    message: response.message ?? (response.success
        ? 'Cập nhật giấy phép lái xe thành công'
        : 'Cập nhật thất bại'),
  );
}
