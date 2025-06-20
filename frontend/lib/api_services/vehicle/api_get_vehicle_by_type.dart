import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/vehicles/motorbike.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/models/vehicles/car.dart';
import 'package:frontend/models/vehicles/coach.dart';
import 'package:frontend/models/vehicles/bike.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiVehicleService {
  static Future<ApiResponse<List<Vehicle>>> getVehiclesByType<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required String type, 
    int page = 1,
    int limit = 10,
    String sort = '-createdAt',
  }) async {
    try {
      final response = await callProtectedApi<T>(
        viewModel,
        endpoint: '/api/vehicles/type/$type?page=$page&limit=$limit&sort=$sort',
        authService: authService,
        method: 'GET',
      );

      if (!response.success || response.data == null || response.data is! Map<String, dynamic>) {
        return ApiResponse(
          success: false,
          message: response.message ?? 'Không lấy được danh sách xe theo loại',
        );
      }

      final data = response.data as Map<String, dynamic>;
      final items = data['data'];

      if (items is! List) {
        return ApiResponse(
          success: false,
          message: 'Dữ liệu không hợp lệ: Không phải danh sách xe',
        );
      }

      final vehicles = items
          .whereType<Map<String, dynamic>>()
          .map(parseVehicle)
          .toList();

      return ApiResponse(
        success: true,
        data: vehicles,
        message: 'Lấy danh sách xe thành công',
      );
    } catch (e, stackTrace) {
      debugPrint('getVehiclesByType error: $e\n$stackTrace');
      return ApiResponse(
        success: false,
        message: 'Lỗi khi lấy xe theo loại: $e',
      );
    }
  }

  /// Parse về đúng model con
  static Vehicle parseVehicle(Map<String, dynamic> item) {
    final type = (item['type'] ?? '').toString().toLowerCase();
    switch (type) {
      case 'car':
        return Car.fromJson(item);
      case 'motor':
      case 'motorbike':
        return Motor.fromJson(item);
      case 'coach':
        return Coach.fromJson(item);
      case 'bike':
        return Bike.fromJson(item);
      default:
        debugPrint('⚠️ Unknown vehicle type: $type, fallback to Vehicle');
        return Vehicle.fromJson(item);
    }
  }
}
