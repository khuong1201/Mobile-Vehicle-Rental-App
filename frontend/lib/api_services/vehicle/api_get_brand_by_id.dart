import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiGetBrandById {
  static Future<ApiResponse<Brand>> getBrandById<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required String brandId,
  }) async {
    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api/brands/$brandId',
      authService: authService,
      method: 'GET',
    );

    if (!response.success || response.data == null) {
      return ApiResponse(
        success: false,
        message: response.message ?? 'Failed to fetch brand',
      );
    }

    try {
      final brand = Brand.fromJson(response.data['data'] as Map<String, dynamic>);
      return ApiResponse(success: true, data: brand);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Failed to parse brand data: $e',
      );
    }
  }
}
