import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiDeleteReview {
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