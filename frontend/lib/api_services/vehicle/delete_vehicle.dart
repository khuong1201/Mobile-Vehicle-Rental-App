import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiVehicleService {
  static Future<ApiResponse<void>> deleteVehicle<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required String vehicleId,
  }) async {
    try {
      final response = await callProtectedApi<T>(
        viewModel,
        endpoint: '/api/vehicles/$vehicleId',
        authService: authService,
        method: 'DELETE',
      );

      if (!response.success) {
        return ApiResponse(
          success: false,
          message: response.message ?? 'Xóa xe thất bại',
        );
      }

      return ApiResponse(
        success: true,
        message: response.message ?? 'Xóa xe thành công',
      );
    } catch (e, stackTrace) {
      debugPrint('Vehicle delete error: $e\n$stackTrace');
      return ApiResponse(success: false, message: 'Lỗi khi xóa xe: $e');
    }
  }
}
