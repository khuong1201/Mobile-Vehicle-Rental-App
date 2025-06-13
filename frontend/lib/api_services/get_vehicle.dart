import 'package:flutter/material.dart';
import 'package:frontend/api_services/api_reponse.dart';
import 'package:frontend/api_services/api_util.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/models/vehicles/car.dart';
import 'package:frontend/models/vehicles/coach.dart';
import 'package:frontend/models/vehicles/motorbike.dart';
import 'package:frontend/models/vehicles/bike.dart';

class ApiGetAllVehicle {
  static Future<ApiResponse<List<Vehicle>>> getAllVehicle<T extends ChangeNotifier>(T viewModel) async {
    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/get-vehicle',
      method: 'GET',
    );

    if (!response.success || response.data == null) {
      return ApiResponse(
        success: false,
        message: response.message ?? 'Unknown error',
      );
    }

    try {
      final List<Vehicle> vehicleList = (response.data as List)
          .whereType<Map<String, dynamic>>()
          .map<Vehicle>((item) {
            final type = item['type']?.toString().toLowerCase() ?? '';
            switch (type) {
              case 'car':
                return Car.fromJson(item);
              case 'motor':
                return Motor.fromJson(item);
              case 'coach':
                return Coach.fromJson(item);
              case 'bike':
                return Bike.fromJson(item);
              default:
                return Vehicle.fromJson(item); // fallback
            }
          })
          .toList();

      return ApiResponse(
        success: true,
        data: vehicleList,
        message: response.message,
      );
    } catch (e, stackTrace) {
      debugPrint('Vehicle parse error: $e\n$stackTrace');
      return ApiResponse(
        success: false,
        message: 'Failed to parse vehicle data',
      );
    }
  }
}
