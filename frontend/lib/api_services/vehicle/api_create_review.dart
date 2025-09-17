import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/review.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiCreateReview {
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
}