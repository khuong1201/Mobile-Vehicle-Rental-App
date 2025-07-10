import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/viettin_payment.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class PaymentViettinApiIPN {
  static Future<ApiResponse<dynamic>> viettinpayment<T extends ChangeNotifier>({
    required T viewModel,
    required AuthService apiAuthService,
    required Map<String, dynamic> paymentData,
  }) async {
    try {
      // Gửi IPN giả lập đến server
      final response = await callProtectedApi(
        viewModel,
        authService: apiAuthService,
        endpoint: '/api/payment/viettin/ipn',
        method: 'POST',
        body: paymentData,
      );

      if (!response.success || response.data == null) {
        return ApiResponse(
          success: false,
          message: response.message ?? 'Gửi IPN Vietin thất bại',
        );
      }

      final viettinPayment = ViettinPayment.fromJson(response.data);

      return ApiResponse(
        success: true,
        data: viettinPayment,
        message: 'Gửi IPN Vietin thành công',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Lỗi khi gửi IPN Vietin: $e',
      );
    }
  }
}
