import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class BookingCreateApi {
  static Future<ApiResponse<dynamic>> createBooking<T extends ChangeNotifier>({
    required T viewModel,
    required AuthService authService,
    required Map<String, dynamic> bookingData,
  }) async {
    try {
      final response = await callProtectedApi(
        viewModel,
        authService: authService,
        endpoint: '/api/bookings/create-booking',
        method: 'POST',
        body: bookingData,
      );

      if (!response.success || response.data == null) {
        return ApiResponse(
          success: false,
          message: response.message ?? 'Tạo booking thất bại',
        );
      }

      final data = response.data;
      return ApiResponse(
        success: true,
        data: data,
        message: 'Tạo booking thành công',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Lỗi tạo booking: $e',
      );
    }
  }
}
