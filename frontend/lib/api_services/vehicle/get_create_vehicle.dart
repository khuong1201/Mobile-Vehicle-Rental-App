import 'dart:convert';
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

class ApiCreatVehicle {
  static Future<ApiResponse<Vehicle>> createVehicle<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required Vehicle vehicle,
    required List<File> imageFiles,
  }) async {
    try {
      debugPrint('🚀 Creating vehicle: ${vehicle.toJson()}');
      debugPrint('📎 Image files: ${imageFiles.map((f) => f.path).toList()}');

      // Chuyển đổi dữ liệu vehicle thành Map<String, String>
      final rawFields = vehicle.toJson()
        ..remove('images')
        ..remove('imagePublicIds');

      final fields = <String, String>{};
      rawFields.forEach((key, value) {
        if (key == 'location' && value is Map) {
          fields[key] = jsonEncode(value);
        } else if (value != null && value.toString().trim().isNotEmpty) {
          fields[key] = value.toString();
        }
      });

      // Đảm bảo các trường bắt buộc
      if (vehicle.brand.isNotEmpty) {
        fields['brand'] = vehicle.brand;
      } else {
        debugPrint('⚠️ Brand is empty');
        return ApiResponse(success: false, message: 'Brand cannot be empty');
      }
      if (vehicle.type.isNotEmpty) {
        fields['type'] = vehicle.type;
      } else {
        debugPrint('⚠️ Type is empty');
        return ApiResponse(success: false, message: 'Type cannot be empty');
      }

      debugPrint('📤 Submitting fields: $fields');

      final response = await callProtectedApi<T>(
        viewModel,
        endpoint: '/api/vehicles/create-vehicle',
        authService: authService,
        method: 'POST',
        isMultipart: true,
        fields: fields,
        files: {'images': imageFiles},
      );

      if (!response.success || response.data == null || response.data is! Map<String, dynamic>) {
        debugPrint('❌ API response failed: ${response.message}');
        return ApiResponse(
          success: false,
          message: response.message ?? 'Failed to create vehicle',
        );
      }

      final data = response.data as Map<String, dynamic>;
      final createdVehicle = parseVehicle(data['data'] ?? data);

      debugPrint('✅ Vehicle created: ${createdVehicle.vehicleName}');
      return ApiResponse(
        success: true,
        data: createdVehicle,
        message: 'Vehicle created successfully',
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Vehicle create error: $e\n$stackTrace');
      return ApiResponse(
        success: false,
        message: 'Failed to create vehicle: $e',
      );
    }
  }

  static Vehicle parseVehicle(Map<String, dynamic> item) {
    final type = (item['type'] ?? '').toString().toLowerCase();
    debugPrint('🔍 Parsing vehicle type: $type');
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