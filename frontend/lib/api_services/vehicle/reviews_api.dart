import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/review.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ReviewsApi {
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
    final endpoint = '/api/reviews/vehicle/$vehicleId?$queryString';

    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: endpoint,
      authService: authService,
      method: 'GET',
    );

    debugPrint('📥 Raw Response: ${response.data}');

    if (response.success) {
      final data = response.data is Map<String, dynamic> ? response.data['data'] : response.data;
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

  static Future<ApiResponse<ReviewModel>> createReview<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required String vehicleId,
    required int rating,
    required String comment,
  }) async {
    final body = {
      'vehicleId': {'_id': vehicleId}, // Gửi vehicleId dưới dạng đối tượng
      'rating': rating,
      'comment': comment,
    };

    debugPrint('🚀 Sending review creation request with body: $body');

    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api/reviews/',
      authService: authService,
      method: 'POST',
      body: body,
    );

    if (response.success && response.data != null && response.data is List && (response.data as List).isNotEmpty) {
      // Ánh xạ dữ liệu đầu tiên trong mảng data sang ReviewModel
      final reviewData = (response.data as List).first;
      final review = ReviewModel.fromJson(reviewData);
      debugPrint('✅ Review created: id=${review.id}, vehicleId=${review.vehicleId}');
      return ApiResponse<ReviewModel>(
        success: true,
        message: response.message ?? 'Review created successfully',
        data: review,
      );
    } else {
      debugPrint('❌ Failed to create review: ${response.message}');
      return ApiResponse<ReviewModel>(
        success: false,
        message: response.message ?? 'Failed to create review',
      );
    }
  }
  
  static Future<ApiResponse<void>> deleteReview<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required String reviewId,
  }) async {
    final endpoint = '/api/reviews/$reviewId';

    debugPrint('🚀 Sending delete review request for reviewId: $reviewId');

    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: endpoint,
      authService: authService,
      method: 'DELETE',
    );

    if (response.success) {
      debugPrint('✅ Review deleted successfully: $reviewId');
      return ApiResponse(
        success: true,
        message: response.message ?? 'Review deleted successfully.',
      );
    } else {
      debugPrint('❌ Failed to delete review: ${response.message}');
      return ApiResponse(
        success: false,
        message: response.message ?? 'Failed to delete review.',
      );
    }
  }
}
