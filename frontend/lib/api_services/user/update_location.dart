import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiUserAddress {
  static Future<ApiResponse<List<dynamic>>> getAddresses<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
  }) async {
    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api/users/get-Address',
      method: 'GET',
      authService: authService,
    );

    if (!response.success || response.data == null || response.data is! Map<String, dynamic>) {
      return ApiResponse(success: false, message: response.message ?? 'Không thể lấy danh sách địa chỉ');
    }

    final data = response.data as Map<String, dynamic>;
    return ApiResponse(
      success: true,
      data: List.from(data['addresses'] ?? []),
      message: data['message'] ?? 'Lấy địa chỉ thành công',
    );
  }

  /// ✅ Cập nhật hoặc thêm mới địa chỉ
  static Future<ApiResponse<dynamic>> updateAddress<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required Map<String, dynamic> addressBody,
  }) async {
    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api/users/update-Address',
      method: 'PUT',
      authService: authService,
      body: addressBody,
    );

    return ApiResponse(
      success: response.success,
      data: response.data,
      message: response.message ?? 'Cập nhật địa chỉ thất bại',
    );
  }

  /// ✅ Xoá địa chỉ theo addressId
  static Future<ApiResponse<dynamic>> deleteAddress<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required String addressId,
  }) async {
    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api/users/delete-Address',
      method: 'DELETE',
      authService: authService,
      body: {"addressId": addressId},
    );

    return ApiResponse(
      success: response.success,
      data: response.data,
      message: response.message ?? 'Xóa địa chỉ thất bại',
    );
  }
}
