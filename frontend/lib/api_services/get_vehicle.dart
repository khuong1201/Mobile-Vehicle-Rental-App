import 'package:flutter/material.dart';
import 'package:frontend/api_services/api_reponse.dart';
import 'package:frontend/api_services/api_util.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/models/vehicles/car.dart';
import 'package:frontend/models/vehicles/coach.dart';
import 'package:frontend/models/vehicles/motorbike.dart';
import 'package:frontend/models/vehicles/bike.dart';
import 'package:frontend/viewmodels/auth_service.dart';

class ApiGetAllVehicle {
  static Future<ApiResponse<List<Vehicle>>> getAllVehicle<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api/vehicles/get-vehicle?page=$page&limit=$limit',
      authService: authService,
      method: 'GET',
    );

    if (!response.success || response.data == null) {
      return ApiResponse(
        success: false,
        message: response.message ?? 'Failed to fetch vehicles: No data received',
      );
    }

    try {
      // Kiểm tra xem response.data có phải là List không
      if (response.data is! List) {
        return ApiResponse(
          success: false,
          message: 'Invalid data format: Expected a list of vehicles',
        );
      }

      final List<Vehicle> vehicleList = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map<Vehicle>((item) {
            final type = item['type']?.toString().toLowerCase() ?? '';
            switch (type) {
              case 'car':
                return Car.fromJson(item);
              case 'motor':
                return Motor.fromJson(item); // Sửa tên class từ Motor thành Motorbike
              case 'coach':
                return Coach.fromJson(item);
              case 'bike':
                return Bike.fromJson(item);
              default:
                debugPrint('Unknown vehicle type: $type, falling back to Vehicle');
                return Vehicle.fromJson(item);
            }
          })
          .toList();

      return ApiResponse(
        success: true,
        data: vehicleList,
        message: 'Vehicles fetched successfully',
      );
    } catch (e, stackTrace) {
      debugPrint('Vehicle parse error: $e\n$stackTrace');
      return ApiResponse(
        success: false,
        message: 'Failed to parse vehicle data: $e',
      );
    }
  }
}