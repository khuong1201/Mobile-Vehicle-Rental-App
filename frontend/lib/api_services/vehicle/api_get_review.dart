import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/review.dart';
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

  debugPrint('📥 Raw Response: ${response.data}');

  // if (response.success == true && response.data is List) {
  //   final items = response.data as List;

  //   final List<ReviewModel> reviewList = items
  //       .whereType<Map<String, dynamic>>()
  //       .map((json) => ReviewModel.fromJson(json))
  //       .toList();

  //   return ApiResponse(
  //     success: true,
  //     data: reviewList,
  //     message: '✅ Fetched reviews successfully.',
  //   );
  // }

  if (response.success) {
    final data = response.data is Map<String, dynamic> ? response.data['reviews'] : response.data;
    if (data is List) {
      final List<ReviewModel> reviewList = data
          .whereType<Map<String, dynamic>>()
          .map((json) => ReviewModel.fromJson(json))
          .toList();

      return ApiResponse(
        success: true,
        data: reviewList,
        message: '✅ Fetched reviews successfully.',
        meta: response.meta,
      );
    } else {
      debugPrint('Error: data is not a List, got ${data.runtimeType}');
      return ApiResponse(
        success: false,
        message: 'Dữ liệu trả về không đúng định dạng (không phải danh sách).',
        meta: response.meta,
      );
    }
  }

  return ApiResponse(
    success: false,
    message: response.message ?? '❌ Failed to fetch reviews.',
  );
}

}
