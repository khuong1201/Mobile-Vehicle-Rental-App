import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/vehicle/api_get_brand.dart';
import 'package:frontend/api_services/vehicle/api_get_vehicle_by_type.dart';
import 'package:frontend/api_services/vehicle/get_vehicle.dart';
import 'package:frontend/models/location/location_for_vehicle.dart';
import 'package:frontend/models/vehicles/bike.dart';
import 'package:frontend/models/vehicles/car.dart';
import 'package:frontend/models/vehicles/coach.dart';
import 'package:frontend/models/vehicles/motorbike.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
import 'package:frontend/viewmodels/user/user_provider_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:frontend/api_services/vehicle/get_create_vehicle.dart';

class VehicleViewModel extends ChangeNotifier {
  final AuthService authService;
  bool get hasMore => _currentPage < _totalPages;
  final List<Vehicle> _vehicles = [];
  final List<Brand> _brands = [];

  bool _isLoadingVehicles = false;
  bool _isLoadingBrands = false;

  String? _errorMessage;
  String? _selectedType;

  int _currentPage = 1;
  int _totalPages = 1;

  List<Vehicle> get vehicles => _vehicles;
  List<Brand> get brands => _brands;
  String? get selectedType => _selectedType;
  bool get isLoading => _isLoadingVehicles || _isLoadingBrands;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  VehicleViewModel(this.authService);

  void changetype(String? type, BuildContext context) {
    if (_selectedType != type) {
      _selectedType = type;
      _currentPage = 1;
      _totalPages = 1;
      fetchVehicles(context, type: type, clearBefore: true);
    }
  }

  Future<void> fetchVehicles(
    BuildContext context, {
    String? type,
    int page = 1,
    int limit = 10,
    bool clearBefore = false,
  }) async {
    if (_isLoadingVehicles) return;

    _isLoadingVehicles = true;
    if (clearBefore) _vehicles.clear();
    notifyListeners();

    final response = type == null || type == 'all'
        ? await ApiGetAllVehicle.getAllVehicle(
            this,
            authService: authService,
            page: page,
            limit: limit,
          )
        : await ApiVehicleService.getVehiclesByType(
            this,
            authService: authService,
            type: type,
            page: page,
            limit: limit,
          );

    if (response.success) {
      _vehicles.addAll(response.data ?? []);
      if (response.meta != null) {
        _currentPage = response.meta!.currentPage;
        _totalPages = response.meta!.totalPages;
      }
    } else {
      _handleAuthError(response.message, context);
    }

    _isLoadingVehicles = false;
    notifyListeners();
  }

  Future<void> fetchBrands(BuildContext context) async {
    if (_isLoadingBrands) return;

    _isLoadingBrands = true;
    _brands.clear();
    notifyListeners();

    final response = await ApiGetAllBrand.getAllBrand(this, authService: authService);

    if (response.success) {
      _brands.addAll(response.data ?? []);
    } else {
      _handleAuthError(response.message, context);
    }

    _isLoadingBrands = false;
    notifyListeners();
  }

  void refresh(BuildContext context) {
    _currentPage = 1;
    _totalPages = 1;
    fetchVehicles(context, type: _selectedType, clearBefore: true);
    fetchBrands(context);
  }

  Future<void> loadMoreVehicles(BuildContext context) async {
    if (_isLoadingVehicles || _currentPage >= _totalPages) return;

    _currentPage += 1;
    await fetchVehicles(
      context,
      type: _selectedType,
      page: _currentPage,
      limit: 10,
      clearBefore: false,
    );
  }

  void _handleAuthError(String? message, BuildContext context) async {
    _errorMessage = message;
    debugPrint('❌ Error: $_errorMessage');
    if (message?.contains('Token refresh failed') == true ||
        message?.contains('Invalid or expired token') == true) {
      final logoutSuccess = await authService.logout();
      if (logoutSuccess && context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  Future<void> createVehicle(
    BuildContext context,
    Map<String, dynamic> data,
    List<File> imageFiles,
  ) async {
    _isLoadingVehicles = true;
    notifyListeners();

    try {
      debugPrint('🚀 Creating vehicle with data: $data');
      debugPrint('📎 Files: ${imageFiles.map((f) => f.path).toList()}');

      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      final user = userViewModel.user;
      if (user == null) {
        debugPrint('❌ No user found');
        _handleAuthError('Vui lòng đăng nhập lại', context);
        return;
      }

      final locationData = data['location'];
      final LocationForVehicle? location = locationData is LocationForVehicle
          ? locationData
          : locationData is Map<String, dynamic>
              ? LocationForVehicle.fromJson(locationData)
              : null;

      if (location == null) {
        debugPrint('❌ Invalid location data');
        _handleAuthError('Dữ liệu vị trí không hợp lệ', context);
        return;
      }

      final brandData = data['brand'];
      final brand = brandData is Map<String, dynamic>
          ? Brand.fromJson(brandData)
          : brandData is String && brandData.isNotEmpty
              ? Brand(id: brandData, brandId: brandData, brandName: 'Unknown')
              : null;

      if (brand == null) {
        debugPrint('❌ Invalid brand data');
        _handleAuthError('Dữ liệu thương hiệu không hợp lệ', context);
        return;
      }

      Vehicle vehicle;
      switch (data['type']?.toLowerCase()) {
        case 'car':
          vehicle = Car(
            id: '',
            vehicleId: '',
            vehicleName: data['vehicleName'] ?? 'Default Car',
            licensePlate: data['licensePlate'] ?? '',
            brand: brand.id,
            yearOfManufacture: data['yearOfManufacture']?.toString() ?? '0',
            images: imageFiles.map((file) => file.path).toList(),
            description: data['description'] ?? 'Default description',
            location: location,
            model: data['model'] ?? '',
            ownerId: user.id,
            ownerEmail: user.email,
            ownerName: user.fullName,
            price: (data['price'] as num?)?.toDouble() ?? 0.0,
            rate: (data['rate'] as num?)?.toDouble() ?? 0.0,
            available: data['available'] as bool? ?? true,
            status: data['status'] as String? ?? 'pending',
            type: data['type'] ?? 'car',
            fuelType: data['fuelType'] as String? ?? '',
            numberOfSeats: double.tryParse(data['numberOfSeats']?.toString() ?? '0') ?? 0,
          );
          break;
        case 'motor':
        case 'motorbike':
          vehicle = Motor(
            id: '',
            vehicleId: '',
            vehicleName: data['vehicleName'] ?? 'Default Motor',
            licensePlate: data['licensePlate'] ?? '',
            brand: brand.id,
            yearOfManufacture: data['yearOfManufacture']?.toString() ?? '0',
            images: imageFiles.map((file) => file.path).toList(),
            description: data['description'] ?? 'Default description',
            location: location,
            model: data['model'] ?? '',
            ownerId: user.id,
            ownerEmail: user.email,
            ownerName: user.fullName,
            price: (data['price'] as num?)?.toDouble() ?? 0.0,
            rate: (data['rate'] as num?)?.toDouble() ?? 0.0,
            available: data['available'] as bool? ?? true,
            status: data['status'] as String? ?? 'pending',
            type: data['type'] ?? 'motor',
            fuelType: data['fuelType'] as String? ?? '',
          );
          break;
        case 'coach':
          vehicle = Coach(
            id: '',
            vehicleId: '',
            vehicleName: data['vehicleName'] ?? 'Default Coach',
            licensePlate: data['licensePlate'] ?? '',
            brand: brand.id,
            yearOfManufacture: data['yearOfManufacture']?.toString() ?? '0',
            images: imageFiles.map((file) => file.path).toList(),
            description: data['description'] ?? 'Default description',
            location: location,
            model: data['model'] ?? '',
            ownerId: user.id,
            ownerEmail: user.email,
            ownerName: user.fullName,
            price: (data['price'] as num?)?.toDouble() ?? 0.0,
            rate: (data['rate'] as num?)?.toDouble() ?? 0.0,
            available: data['available'] as bool? ?? true,
            status: data['status'] as String? ?? 'pending',
            type: data['type'] ?? 'coach',
            fuelType: data['fuelType'] as String? ?? '',
            numberOfSeats: double.tryParse(data['numberOfSeats']?.toString() ?? '0') ?? 0,
          );
          break;
        case 'bike':
          vehicle = Bike(
            id: '',
            vehicleId: '',
            vehicleName: data['vehicleName'] ?? 'Default Bike',
            licensePlate: data['licensePlate'] ?? '',
            brand: brand.id,
            yearOfManufacture: data['yearOfManufacture']?.toString() ?? '0',
            images: imageFiles.map((file) => file.path).toList(),
            description: data['description'] ?? 'Default description',
            location: location,
            model: data['model'] ?? '',
            ownerId: user.id,
            ownerEmail: user.email,
            ownerName: user.fullName,
            price: (data['price'] as num?)?.toDouble() ?? 0.0,
            rate: (data['rate'] as num?)?.toDouble() ?? 0.0,
            available: data['available'] as bool? ?? true,
            status: data['status'] as String? ?? 'pending',
            type: data['type'] ?? 'bike',
            typeOfBike: data['typeOfBike'] as String? ?? '',
          );
          break;
        default:
          vehicle = Vehicle(
            id: '',
            vehicleId: '',
            vehicleName: data['vehicleName'] ?? 'Default Vehicle',
            licensePlate: data['licensePlate'] ?? '',
            brand: brand.id,
            yearOfManufacture: data['yearOfManufacture']?.toString() ?? '0',
            images: imageFiles.map((file) => file.path).toList(),
            description: data['description'] ?? 'Default description',
            location: location,
            model: data['model'] ?? '',
            ownerId: user.id,
            ownerEmail: user.email,
            ownerName: user.fullName,
            price: (data['price'] as num?)?.toDouble() ?? 0.0,
            rate: (data['rate'] as num?)?.toDouble() ?? 0.0,
            available: data['available'] as bool? ?? true,
            status: data['status'] as String? ?? 'pending',
            type: data['type'] ?? 'car',
          );
          break;
      }

      final response = await ApiCreatVehicle.createVehicle(
        this,
        authService: authService,
        vehicle: vehicle,
        imageFiles: imageFiles,
      );

      if (response.success && response.data != null) {
        _vehicles.insert(0, response.data!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Vehicle ${data['type']} created successfully!')),
        );
      } else {
        _handleAuthError(response.message ?? 'Failed to create vehicle', context);
      }
    } catch (e) {
      debugPrint('❌ Error creating vehicle: $e');
      _handleAuthError('Error creating vehicle: $e', context);
    } finally {
      _isLoadingVehicles = false;
      notifyListeners();
    }
  }
}