import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/viettin_payment.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class PaymentViettinApi {
  static Future<ApiResponse<dynamic>>
  createViettinPayment<T extends ChangeNotifier>({
    required T viewModel,
    required AuthService apiAuthService,
    required Map<String, dynamic> paymentData,
  }) async {
    try {
      final response = await callProtectedApi(
        viewModel,
        authService: apiAuthService,
        endpoint: '/api/payment/create-viettin',
        method: 'POST',
        body: paymentData,
      );

      if (!response.success || response.data == null) {
        return ApiResponse(
          success: false,
          message: response.message ?? 'Tạo thanh toán Viettin thất bại',
        );
      }

      final viettinPayment = ViettinPayment.fromJson(response.data);
      return ApiResponse(
        success: true,
        data: viettinPayment,
        message: 'Tạo thanh toán Viettin thành công',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Lỗi tạo thanh toán Viettin: $e',
      );
    }
  }
}
