import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/vehicles/bike.dart';
import 'package:frontend/models/vehicles/car.dart';
import 'package:frontend/models/vehicles/coach.dart';
import 'package:frontend/models/vehicles/motorbike.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiGetAllVehicle {
  static Future<ApiResponse<Vehicle>> createVehicle<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required Vehicle vehicle,
    required List<File> imageFiles, // danh sách ảnh truyền vào
  }) async {
    try {
      final fields = vehicle.toJson()
        ..remove('images') // xoá vì gửi qua multipart
        ..remove('imagePublicIds');

      final response = await callProtectedApi<T>(
        viewModel,
        endpoint: '/api/vehicles/create-vehicle',
        authService: authService,
        method: 'POST',
        isMultipart: true,
        fields: fields.map((key, value) => MapEntry(key, value.toString())),
        files: {
          'images': imageFiles, // truyền key đúng như backend yêu cầu
        },
      );

      if (!response.success || response.data == null || response.data is! Map<String, dynamic>) {
        return ApiResponse(
          success: false,
          message: response.message ?? 'Failed to create vehicle',
        );
      }

      final data = response.data as Map<String, dynamic>;
      final createdVehicle = parseVehicle(data['data'] ?? data);

      return ApiResponse(
        success: true,
        data: createdVehicle,
        message: 'Vehicle created successfully',
      );
    } catch (e, stackTrace) {
      debugPrint('Vehicle create error: $e\n$stackTrace');
      return ApiResponse(
        success: false,
        message: 'Failed to create vehicle: $e',
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
