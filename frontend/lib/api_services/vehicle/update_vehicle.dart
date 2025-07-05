import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/vehicles/motorbike.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/models/vehicles/car.dart';
import 'package:frontend/models/vehicles/coach.dart';
import 'package:frontend/models/vehicles/bike.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiVehicleUpdate {
  static Future<ApiResponse<Vehicle>> updateVehicle<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required String vehicleId,
    required Vehicle vehicle,
    List<File>? images,
  }) async {
    try {
      final body = vehicle.toJson();

      final response = await callProtectedApi<T>(
        viewModel,
        endpoint: '/api/vehicles/$vehicleId',
        authService: authService,
        method: 'PUT',
        body: body,
        files: images != null && images.isNotEmpty
            ? {'images': images}
            : null,
      );

      if (!response.success || response.data == null || response.data is! Map<String, dynamic>) {
        return ApiResponse(
          success: false,
          message: response.message ?? 'Failed to update vehicle',
        );
      }

      final data = response.data as Map<String, dynamic>;
      final updatedVehicle = parseVehicle(data['data'] ?? data);

      return ApiResponse(
        success: true,
        data: updatedVehicle,
        message: 'Vehicle updated successfully',
      );
    } catch (e, stackTrace) {
      debugPrint('Vehicle update error: $e\n$stackTrace');
      return ApiResponse(
        success: false,
        message: 'Failed to update vehicle: $e',
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
