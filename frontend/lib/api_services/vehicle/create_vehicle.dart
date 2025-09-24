import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/util/api_util.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'dart:convert';

import 'package:frontend/viewmodels/auth/auth_service.dart';

class ApiCreateVehicle {
  static Future<ApiResponse<Vehicle>> createVehicle<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required Vehicle vehicle,
    required List<File> imageFiles,
  }) async {
    try {
      debugPrint('🚀 Creating vehicle: ${vehicle.toJson()}');
      debugPrint('📎 Image files: ${imageFiles.map((f) => f.path).toList()}');

      // Sử dụng toApiJson để chuẩn bị dữ liệu
      final fields = vehicle.toApiJson();

      // Kiểm tra các trường bắt buộc
      if (vehicle.brandId.isEmpty) {
        return ApiResponse(success: false, message: 'BrandId cannot be empty');
      }
      if (vehicle.type.isEmpty) {
        return ApiResponse(success: false, message: 'Type cannot be empty');
      }
      if (vehicle.vehicleName.isEmpty) {
        return ApiResponse(success: false, message: 'VehicleName cannot be empty');
      }
      if (vehicle.licensePlate.isEmpty) {
        return ApiResponse(success: false, message: 'LicensePlate cannot be empty');
      }
      if (vehicle.ownerId.isEmpty) {
        return ApiResponse(success: false, message: 'OwnerId cannot be empty');
      }
      if (vehicle.location == null) {
        return ApiResponse(success: false, message: 'Location is required');
      }
      if (vehicle.location!.coordinates.length != 2) {
        return ApiResponse(success: false, message: 'Location coordinates invalid');
      }

      debugPrint('📤 Submitting vehicle data: ${jsonEncode(fields)}');

      // 🚀 Request duy nhất: Gửi cả fields + files
      final vehicleResponse = await callProtectedApi<T>(
        viewModel,
        endpoint: '/api/vehicles/',
        authService: authService,
        method: 'POST',
        isMultipart: true,
        fields: fields,              // dữ liệu text
        files: {'images': imageFiles}, // gửi kèm ảnh luôn
      );

      if (!vehicleResponse.success ||
          vehicleResponse.data == null ||
          vehicleResponse.data is! Map<String, dynamic>) {
        debugPrint('❌ API response failed: ${vehicleResponse.message}');
        return ApiResponse(
          success: false,
          message: vehicleResponse.message ?? 'Failed to create vehicle',
        );
      }

      final data = vehicleResponse.data as Map<String, dynamic>;
      final createdVehicle = Vehicle.fromJson(data['data'] ?? data);

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
}
