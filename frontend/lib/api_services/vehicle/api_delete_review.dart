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
    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api/review/$reviewId',
      authService: authService,
      method: 'DELETE',
    );

    return ApiResponse(
      success: response.success,
      message: response.message ?? (response.success ? 'Review deleted' : 'Failed to delete review'),
    );
  }
}
