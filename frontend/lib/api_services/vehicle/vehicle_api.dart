import 'dart:convert';
import 'dart:io';

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

class VehicleApi {
  static Future<ApiResponse<List<Vehicle>>> getAllVehicle<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    int page = 1,
    int limit = 10,

  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      'sort': '-createdAt',
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

      final vehicleList = items
          .whereType<Map<String, dynamic>>()
          .map(parseVehicle)
          .toList();

      final meta = PaginationMeta(
        currentPage: data['currentPage'] ?? 1,
        totalPages: data['totalPages'] ?? 1,
        totalItems: data['totalItems'] ?? vehicleList.length,
      );

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

  static Future<ApiResponse<List<Vehicle>>> getVehicleByOwner<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    int page = 1,
    int limit = 10,
    required String userId,
  }) async {
    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api/vehicles/owner/$userId?page=$page&limit=$limit',
      authService: authService,
      method: 'GET',
    );

    if (!response.success || response.data == null || response.data is! Map<String, dynamic>) {
      return ApiResponse(
        success: false,
        message: response.message ?? 'Failed to fetch vehicles by owner',
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

      final vehicleList = items
          .whereType<Map<String, dynamic>>()
          .map(parseVehicle)
          .toList();

      return ApiResponse(
        success: true,
        data: vehicleList,
        message: 'Vehicles by owner fetched successfully',
      );
    } catch (e, stackTrace) {
      debugPrint('Vehicle by owner parse error: $e\n$stackTrace');
      return ApiResponse(
        success: false,
        message: 'Failed to parse vehicles by owner: $e',
      );
    }
  }

  static Future<ApiResponse<List<Vehicle>>> getVehicleByType<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required String type,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      'sort': '-createdAt',
    };

    final queryString = Uri(queryParameters: queryParams).query;

    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api/vehicles/type/$type?$queryString',
      authService: authService,
      method: 'GET',
    );

    if (!response.success || response.data == null || response.data is! Map<String, dynamic>) {
      return ApiResponse(
        success: false,
        message: response.message ?? 'Failed to fetch vehicles by type',
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

      final vehicleList = items
          .whereType<Map<String, dynamic>>()
          .map(parseVehicle)
          .toList();

      final meta = PaginationMeta(
        currentPage: data['currentPage'] ?? 1,
        totalPages: data['totalPages'] ?? 1,
        totalItems: data['totalItems'] ?? vehicleList.length,
      );

      return ApiResponse(
        success: true,
        data: vehicleList,
        message: 'Vehicles by type fetched successfully',
        meta: meta,
      );
    } catch (e, stackTrace) {
      debugPrint('Vehicle by type parse error: $e\n$stackTrace');
      return ApiResponse(
        success: false,
        message: 'Failed to parse vehicles by type: $e',
      );
    }
  }

  static Future<ApiResponse<Vehicle>> getVehicleById<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required String vehicleId,
  }) async {
    final response = await callProtectedApi<T>(
      viewModel,
      endpoint: '/api/vehicles/$vehicleId',
      authService: authService,
      method: 'GET',
    );

    if (!response.success || response.data == null || response.data is! Map<String, dynamic>) {
      return ApiResponse(
        success: false,
        message: response.message ?? 'Failed to fetch vehicles by vehicleId',
      );
    }

    try {
      final Map<String, dynamic> data = response.data;
      final vehicleData = parseVehicle(data['data']);

      
      return ApiResponse(
        success: true,
        data: vehicleData,
        message: 'Vehicles by vehicleId fetched successfully',
      );
    } catch (e, stackTrace) {
      debugPrint('Vehicle by vehicleId parse error: $e\n$stackTrace');
      return ApiResponse(
        success: false,
        message: 'Failed to parse vehicles by vehicleId: $e',
      );
    }
  }

  static Future<ApiResponse<Vehicle>> createVehicle<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required Vehicle vehicle,
    required List<File> imageFiles,
  }) async {
    try {
      debugPrint('🚀 Creating vehicle: ${vehicle.toJson()}');
      debugPrint('📎 Image files: ${imageFiles.map((f) => f.path).toList()}');

      final fields = vehicle.toApiJson();

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

      final vehicleResponse = await callProtectedApi<T>(
        viewModel,
        endpoint: '/api/vehicles/',
        authService: authService,
        method: 'POST',
        isMultipart: true,
        fields: fields,          
        files: {'images': imageFiles},
      );

      if (!vehicleResponse.success || vehicleResponse.data == null || vehicleResponse.data is! Map<String, dynamic>) {
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

  static Future<ApiResponse<void>> deleteVehicle<T extends ChangeNotifier>(
    T viewModel, {
    required AuthService authService,
    required String vehicleId,
  }) async {
    try {
      final response = await callProtectedApi<T>(
        viewModel,
        endpoint: '/api/vehicles/$vehicleId',
        authService: authService,
        method: 'DELETE',
      );

      if (!response.success) {
        return ApiResponse(
          success: false,
          message: response.message ?? 'Xóa xe thất bại',
        );
      }

      return ApiResponse(
        success: true,
        message: response.message ?? 'Xóa xe thành công',
      );
    } catch (e, stackTrace) {
      debugPrint('Vehicle delete error: $e\n$stackTrace');
      return ApiResponse(success: false, message: 'Lỗi khi xóa xe: $e');
    }
  }

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
