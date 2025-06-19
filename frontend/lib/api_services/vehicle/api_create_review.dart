import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiCreateReview {
  static Future<ApiResponse<void>> createReview<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required String vehicleId,
    required int rating,
    required String comment,
  }) async {
    final body = {
      'vehicleId': vehicleId,
      'rating': rating,
      'comment': comment,
    };

    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api/review/create-review',
      authService: authService,
      method: 'POST',
      body: body,
    );

    return ApiResponse(
      success: response.success,
      message: response.message ?? (response.success ? 'Review created' : 'Failed to create review'),
    );
  }
}
