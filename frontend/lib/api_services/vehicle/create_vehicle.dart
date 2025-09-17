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
        debugPrint('⚠️ BrandId is empty');
        return ApiResponse(success: false, message: 'BrandId cannot be empty');
      }
      if (vehicle.type.isEmpty) {
        debugPrint('⚠️ Type is empty');
        return ApiResponse(success: false, message: 'Type cannot be empty');
      }
      if (vehicle.vehicleName.isEmpty) {
        debugPrint('⚠️ VehicleName is empty');
        return ApiResponse(success: false, message: 'VehicleName cannot be empty');
      }
      if (vehicle.licensePlate.isEmpty) {
        debugPrint('⚠️ LicensePlate is empty');
        return ApiResponse(success: false, message: 'LicensePlate cannot be empty');
      }
      if (vehicle.ownerId.isEmpty) {
        debugPrint('⚠️ OwnerId is empty');
        return ApiResponse(success: false, message: 'OwnerId cannot be empty');
      }
      if (vehicle.location == null) {
        return ApiResponse(success: false, message: 'Location is required');
      }
      if (vehicle.location!.coordinates.length != 2) {
        return ApiResponse(success: false, message: 'Location coordinates invalid');
      }

      debugPrint('📤 Submitting vehicle data: ${jsonEncode(fields)}');

      // Request 1: Gửi dữ liệu vehicle với JSON
      final vehicleResponse = await callProtectedApi<T>(
        viewModel,
        endpoint: '/api/vehicles/',
        authService: authService,
        method: 'POST',
        isMultipart: false,
        body: fields, // Gửi location dưới dạng object
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
      final vehicleId = createdVehicle.vehicleId; // Lấy vehicleId

      debugPrint('✅ Vehicle created: ${createdVehicle.vehicleName}');

      // Request 2: Gửi hình ảnh nếu có
      if (imageFiles.isNotEmpty) {
        debugPrint('📤 Uploading images for vehicleId: $vehicleId');
        final imageResponse = await callProtectedApi<T>(
          viewModel,
          endpoint: '/api/vehicles/$vehicleId/images',
          authService: authService,
          method: 'POST',
          isMultipart: true,
          fields: {'vehicleId': vehicleId},
          files: {'images': imageFiles},
        );

        if (!imageResponse.success) {
          debugPrint('❌ Image upload failed: ${imageResponse.message}');
          // Vehicle đã được tạo, nhưng có thể thông báo lỗi upload ảnh
        } else {
          debugPrint('✅ Images uploaded successfully');
        }
      }

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