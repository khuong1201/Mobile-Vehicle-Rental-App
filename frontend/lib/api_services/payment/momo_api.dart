import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/momo_payment.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class PaymentMomoApi {
  static Future<ApiResponse<dynamic>>
  createMomoPayment<T extends ChangeNotifier>({
    required T viewModel,
    required AuthService apiAuthService,
    required Map<String, dynamic> paymentData,
  }) async {
    try {
      final response = await callProtectedApi(
        viewModel,
        authService: apiAuthService,
        endpoint: '/api/payments/create-momo-payment',
        method: 'POST',
        body: paymentData,
      );

      if (!response.success || response.data == null) {
        return ApiResponse(
          success: false,
          message: response.message ?? 'Tạo thanh toán MoMo thất bại',
        );
      }

      final momoPayment = MomoPayment.fromJson(response.data);
      return ApiResponse(
        success: true,
        data: momoPayment,
        message: 'Tạo thanh toán MoMo thành công',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Lỗi tạo thanh toán MoMo: $e',
      );
    }
  }
}
