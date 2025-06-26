import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/review.dart';
import 'package:frontend/models/meta.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiGetReviewByVehicle {
  static Future<ApiResponse<List<ReviewModel>>> getReviews<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required String vehicleId,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final queryString = Uri(queryParameters: queryParams).query;
    final endpoint = '/api/reviews/$vehicleId?$queryString';

    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: endpoint,
      authService: authService,
      method: 'GET',
    );

    if (response.success == true && response.data == null) {
      return ApiResponse(
        success: true,
        message: 'none reviews',
      );
    }
    if (!response.success || response.data is! Map<String, dynamic>) {
      return ApiResponse(
        success: false,
        message: response.message ?? '❌ Failed to fetch reviews.',
      );
    }

    try {
      final Map<String, dynamic> data = response.data;
      final items = data['data'];

      if (items is! List) {
        return ApiResponse(
          success: false,
          message: '⚠️ Invalid format: review list must be an array.',
        );
      }

      final List<ReviewModel> reviewList = items
          .whereType<Map<String, dynamic>>()
          .map((json) => ReviewModel.fromJson(json))
          .toList();

      final meta = PaginationMeta.fromJson(data);

      return ApiResponse(
        success: true,
        data: reviewList,
        meta: meta,
        message: '✅ Fetched reviews successfully.',
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Review parsing error: $e\n$stackTrace');
      return ApiResponse(
        success: false,
        message: '❌ Failed to parse review data: $e',
      );
    }
  }
}
