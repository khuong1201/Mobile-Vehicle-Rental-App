import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/meta.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/models/vehicles/car.dart';
import 'package:frontend/models/vehicles/coach.dart';
import 'package:frontend/models/vehicles/motorbike.dart';
import 'package:frontend/models/vehicles/bike.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiGetAllVehicle {
  static Future<ApiResponse<List<Vehicle>>> getAllVehicle<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    int page = 1,
    int limit = 10,
    String? type,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (type != null) 'type': type,
    };

    final queryString = Uri(queryParameters: queryParams).query;

    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api/vehicles/?$queryString',
      authService: authService,
      method: 'GET',
    );

    if (!response.success || response.data == null || response.data is! Map<String, dynamic>) {
      return ApiResponse(
        success: false,
        message: response.message ?? 'Failed to fetch vehicles: No data received or wrong format',
      );
    }

    try {
      final Map<String, dynamic> data = response.data;
      final items = data['data'];

      if (items is! List) {
        return ApiResponse(
          success: false,
          message: 'Invalid data format: Expected a list of vehicles',
        );
      }

      final vehicleList = items.whereType<Map<String, dynamic>>().map(parseVehicle).toList();
      final meta = PaginationMeta.fromJson(data);

      return ApiResponse(
        success: true,
        data: vehicleList,
        message: 'Vehicles fetched successfully',
        meta: meta,
      );
    } catch (e, stackTrace) {
      debugPrint('Vehicle parse error: $e\n$stackTrace');
      return ApiResponse(
        success: false,
        message: 'Failed to parse vehicle data: $e',
      );
    }
  }

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
