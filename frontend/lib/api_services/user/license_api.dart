import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class DriverLicenseApi {
  static Future<ApiResponse<Map<String, dynamic>>> create({
    required ChangeNotifier viewModel,
    required AuthService authService,
    required String typeOfDriverLicense,
    required String classLicense,
    required String licenseNumber,
    required File frontImage,
    required File backImage,
  }) async {
    final userId = authService.user?.userId;
    if (userId == null) {
      return ApiResponse(success: false, message: "User not authenticated");
    }

    final response = await callProtectedApi(
      viewModel,
      authService: authService,
      endpoint: '/api/users/$userId/license',
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

    return ApiResponse<Map<String, dynamic>>(
      success: response.success,
      data: response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : null,
      message: response.message ??
          (response.success ? 'Created successfully' : 'Creation failed'),
    );
  }

  /// Cập nhật license (có thể gửi file hoặc không)
  static Future<ApiResponse<Map<String, dynamic>>> update({
    required ChangeNotifier viewModel,
    required AuthService authService,
    required String typeOfDriverLicense,
    required String classLicense,
    required String licenseNumber,
    File? frontImage,
    File? backImage,
  }) async {
    final userId = authService.user?.userId;
    if (userId == null) {
      return ApiResponse(success: false, message: "User not authenticated");
    }

    final files = <String, List<File>>{};
    if (frontImage != null) files['driverLicenseFront'] = [frontImage];
    if (backImage != null) files['driverLicenseBack'] = [backImage];

    final response = await callProtectedApi(
      viewModel,
      authService: authService,
      endpoint: '/api/users/$userId/license',
      method: 'PUT',
      isMultipart: files.isNotEmpty, 
      fields: {
        'typeOfDriverLicense': typeOfDriverLicense,
        'classLicense': classLicense,
        'licenseNumber': licenseNumber,
      },
      files: files.isNotEmpty ? files : null,
    );

    return ApiResponse<Map<String, dynamic>>(
      success: response.success,
      data: response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : null,
      message: response.message ??
          (response.success ? 'Updated successfully' : 'Update failed'),
    );
  }

  /// Xóa license
  static Future<ApiResponse<Map<String, dynamic>>> delete({
    required ChangeNotifier viewModel,
    required AuthService authService,
    required String licenseId,
  }) async {
    final userId = authService.user?.userId;
    if (userId == null) {
      return ApiResponse(success: false, message: "User not authenticated");
    }

    final response = await callProtectedApi(
      viewModel,
      authService: authService,
      endpoint: '/api/users/$userId/license/$licenseId',
      method: 'DELETE',
      isMultipart: false, 
    );

    return ApiResponse<Map<String, dynamic>>(
      success: response.success,
      data: response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : null,
      message: response.message ??
          (response.success ? 'Deleted successfully' : 'Delete failed'),
    );
  }
}
