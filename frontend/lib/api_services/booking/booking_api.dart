import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class BookingApi {
  static Future<ApiResponse<dynamic>> createBooking<T extends ChangeNotifier>({
    required T viewModel,
    required AuthService authService,
    required Map<String, dynamic> bookingData,
  }) async {
    const requiredFields = [
      'vehicleId',
      'renterId',
      'ownerId',
      'pickupLocation',
      'dropoffLocation',
      'pickupDateTime',
      'dropoffDateTime',
      'basePrice',
    ];
    for (var field in requiredFields) {
      if (!bookingData.containsKey(field) ||
          bookingData[field] == null ||
          bookingData[field] == '') {
        return ApiResponse(
          success: false,
          message: 'Thiếu trường bắt buộc: $field',
        );
      }
    }

    try {
      final response = await callProtectedApi(
        viewModel,
        authService: authService,
        endpoint: '/api/bookings/',
        method: 'POST',
        body: bookingData,
      );

      if (!response.success || response.data == null) {
        return ApiResponse(
          success: false,
          message: response.message ?? 'Tạo booking thất bại',
        );
      }
      // Parse JSON thành Booking
      final res = response.data as Map<String, dynamic>;
      final data = res['data'] as Map<String, dynamic>;
      final booking = Booking.fromJson(data);

      return ApiResponse(
        success: true,
        data: booking,
        message: 'Tạo booking thành công',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Lỗi tạo booking: $e',
      );
    }
  }

  static Future<ApiResponse<Booking>> getBookingById<T extends ChangeNotifier>({
    required T viewModel,
    required AuthService authService,
    required String bookingId,
  }) async {
    if (bookingId.isEmpty) {
      return ApiResponse(
        success: false,
        message: 'bookingId không được để trống',
      );
    }

    try {
      final response = await callProtectedApi(
        viewModel,
        authService: authService,
        endpoint: '/api/bookings/$bookingId',
        method: 'GET',
      );

      if (!response.success || response.data == null) {
        return ApiResponse(
          success: false,
          message: response.message ?? 'Lấy thông tin booking thất bại',
        );
      }

      final bookingJson = response.data as Map<String, dynamic>;
      final booking = Booking.fromJson(bookingJson);

      return ApiResponse(
        success: true,
        data: booking,
        message: 'Lấy thông tin booking thành công',
      );
      
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Lỗi khi lấy thông tin booking: $e',
      );
    }
  }

  static Future<ApiResponse<List<Booking>>> getUserBookings<T extends ChangeNotifier>({
    required T viewModel,
    required AuthService authService,
  }) async {
    try {
      final response = await callProtectedApi(
        viewModel,
        authService: authService,
        endpoint: '/api/bookings/user/me',
        method: 'GET',
      );

      if (!response.success || response.data == null) {
        return ApiResponse(
          success: false,
          message: response.message ?? 'Lấy thông tin booking thất bại',
        );
      }

      final res = response.data as Map<String, dynamic>;
      final List<dynamic> dataList = res['data'] ?? [];

      final List<Booking> bookings = dataList.map((item) => Booking.fromJson(item)).toList();

      return ApiResponse(
        success: true,
        data: bookings,
        message: 'Lấy thông tin booking thành công',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Lỗi khi lấy thông tin booking: $e',
      );
    }
  }
}