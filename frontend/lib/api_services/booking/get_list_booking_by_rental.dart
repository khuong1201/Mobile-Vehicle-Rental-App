import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class BookingGetByRenterApi {
  static Future<ApiResponse<List<Booking>>> getBookingsByRenter<T extends ChangeNotifier>({
    required T viewModel,
    required AuthService authService,
    required String renterId,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await callProtectedApi(
      viewModel,
      authService: authService,
      endpoint: '/api/bookings/renter/$renterId?page=$page&limit=$limit',
      method: 'GET',
    );

    if (!response.success || response.data == null || response.data is! List) {
      return ApiResponse(success: false, message: response.message ?? 'Lỗi khi lấy danh sách');
    }

    final data = response.data as List;
    final bookings = data.map((e) => Booking.fromJson(e)).toList();

    return ApiResponse(success: true, data: bookings);
  }
}
