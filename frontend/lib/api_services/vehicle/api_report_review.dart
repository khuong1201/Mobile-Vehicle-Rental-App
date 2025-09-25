import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiReportReview {
  static Future<ApiResponse<void>> reportReview<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required String reviewId,
    required String vehicleId,
    required String reason,
  }) async {
    final body = {
      'reviewId': reviewId,
      'vehicleId': vehicleId,
      'reason': reason,
    };

    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api//review-reports',
      authService: authService,
      method: 'POST',
      body: body,
    );

    return ApiResponse(
      success: response.success,
      message: response.message ?? (response.success ? 'Review reported' : 'Failed to report review'),
    );
  }
}
