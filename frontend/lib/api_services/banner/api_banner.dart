import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/banner.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiGetAllBanner {
  static Future<ApiResponse<List<BannerApp>>> getAllBanner<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
  }) async {
    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api/banners/get-all-banner',
      authService: authService,
      method: 'GET',
    );

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
        dataList = response.data as List; 
        debugPrint('Parsing direct list response');
      } else if (response.data is Map<String, dynamic> &&
          response.data['data'] is List) {
        dataList = response.data['data'] as List; 
        debugPrint('Parsing nested "data" list response');
      } else {
        return ApiResponse(
          success: false,
          message: 'Invalid data format: Expected a list or map with a list under "data"',
        );
      }

      final List<BannerApp> bannerList = dataList
          .whereType<Map<String, dynamic>>()
          .map<BannerApp>((item) {
            debugPrint('Parsing brand: $item');
            return BannerApp.fromJson(item);
          })
          .toList();

      return ApiResponse(
        success: true,
        data: bannerList,
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