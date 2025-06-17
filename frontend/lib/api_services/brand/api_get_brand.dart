import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiGetAllBrand {
  static Future<ApiResponse<List<Brand>>> getAllBrand<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
  }) async {
    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api/brands/get-all-brand',
      authService: authService,
      method: 'GET',
    );

    // Log raw response for debugging
    debugPrint('API Response - Success: ${response.success}, '
        'Data: ${response.data}, Message: ${response.message}');

    if (!response.success || response.data == null) {
      return ApiResponse(
        success: false,
        message: response.message ?? 'Failed to fetch brands: No data received',
      );
    }

    try {
      List<dynamic> dataList;
      if (response.data is List) {
        dataList = response.data as List; // Direct list
        debugPrint('Parsing direct list response');
      } else if (response.data is Map<String, dynamic> &&
          response.data['data'] is List) {
        dataList = response.data['data'] as List; // Nested under "data"
        debugPrint('Parsing nested "data" list response');
      } else {
        return ApiResponse(
          success: false,
          message: 'Invalid data format: Expected a list or map with a list under "data"',
        );
      }

      final List<Brand> brandList = dataList
          .whereType<Map<String, dynamic>>()
          .map<Brand>((item) {
            debugPrint('Parsing brand: $item');
            return Brand.fromJson(item);
          })
          .toList();

      return ApiResponse(
        success: true,
        data: brandList,
        message: 'Brands fetched successfully',
      );
    } catch (e, stackTrace) {
      debugPrint('Brand parse error: $e\n$stackTrace');
      return ApiResponse(
        success: false,
        message: 'Failed to parse brand data: $e',
      );
    }
  }
}