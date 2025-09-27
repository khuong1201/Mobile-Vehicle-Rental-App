import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/vehicle/brands_api.dart';
import 'package:frontend/api_services/vehicle/vehicle_api.dart';
import 'package:frontend/models/bank.dart';
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

class VehicleViewModel extends ChangeNotifier {
  final AuthService authService;
  bool get hasMore => _currentPage < _totalPages;
  final List<Vehicle> _vehicles = [];
  final List<Brand> _brands = [];

  Vehicle? _currentVehicle;
  Vehicle? get currentVehicle => _currentVehicle;

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

  void changeType(String? type, BuildContext context) {
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
        ? await VehicleApi.getAllVehicle(
            this,
            authService: authService,
            page: page,
            limit: limit,
          )
        : await VehicleApi.getVehicleByType(
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

  Future<void> fetchVehiclesByOwner(
    BuildContext context, {
    required String userId,
    int page = 1,
    int limit = 10,
    bool clearBefore = false,
  }) async {
    if (_isLoadingVehicles) return;

    _isLoadingVehicles = true;
    if (clearBefore) _vehicles.clear();
    notifyListeners();

    final response = await VehicleApi.getVehicleByOwner(
      this,
      authService: authService,
      userId: userId,
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

  Future<void> fetchVehicleById(
    BuildContext context, {
    required String vehicleId,
    bool clearBefore = false,
  }) async {
    if (_isLoadingVehicles) return;

    _isLoadingVehicles = true;
    if (clearBefore) _vehicles.clear();
    notifyListeners();

    final response = await VehicleApi.getVehicleById(
      this,
      authService: authService,
      vehicleId: vehicleId,
    );

    if (response.success) {
      _currentVehicle = response.data!;
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

    final response = await BrandsApi.getAllBrand(
      this,
      authService: authService,
    );

    if (response.success) {
      _brands.addAll(response.data ?? []);
    } else {
      _handleAuthError(response.message, context);
    }

    _isLoadingBrands = false;
    notifyListeners();
  }

  Future<Brand?> fetchBrandById(BuildContext context, String brandId) async {
    try {
      debugPrint('Fetching brand with ID: $brandId');
      final response = await BrandsApi.getBrandById(
        this,
        authService: authService,
        brandId: brandId,
      );
      debugPrint('API Response: ${response.success}, Data: ${response.data}');
      if (response.success && response.data != null) {
        debugPrint(
            'Brand details: id=${response.data!.id}, name=${response.data!.brandName}, image=${response.data!.brandImage}');
        return response.data!;
      } else {
        _handleAuthError(response.message, context);
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error fetching brand: $e');
      return null;
    }
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
    message;
    debugPrint('❌ Error: $message');
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

      // Kiểm tra các trường bắt buộc
      if (data['vehicleName'] == null || data['vehicleName'].toString().isEmpty) {
        debugPrint('❌ VehicleName is empty');
        _handleAuthError('Tên xe không được để trống', context);
        return;
      }
      if (data['licensePlate'] == null || data['licensePlate'].toString().isEmpty) {
        debugPrint('❌ LicensePlate is empty');
        _handleAuthError('Biển số xe không được để trống', context);
        return;
      }
      if (data['brandId'] == null || data['brandId'].toString().isEmpty) {
        debugPrint('❌ BrandId is empty');
        _handleAuthError('Thương hiệu không được để trống', context);
        return;
      }
      if (data['type'] == null || data['type'].toString().isEmpty) {
        debugPrint('❌ Type is empty');
        _handleAuthError('Loại xe không được để trống', context);
        return;
      }

      // Xử lý location
      final locationData = data['location'];
      LocationForVehicle? location;

      if (locationData is LocationForVehicle) {
        location = locationData;
      } else if (locationData is Map<String, dynamic>) {
        location = LocationForVehicle.fromJson(locationData);
      } else if (locationData is String) {
        try {
          final Map<String, dynamic> parsed = Map<String, dynamic>.from(
              jsonDecode(locationData) as Map<String, dynamic>);
          location = LocationForVehicle.fromJson(parsed);
        } catch (e) {
          debugPrint('❌ Invalid location JSON: $e');
          _handleAuthError('Dữ liệu vị trí không hợp lệ', context);
          return;
        }
      }

      if (location == null) {
        debugPrint('❌ Location is null');
        _handleAuthError('Dữ liệu vị trí không hợp lệ', context);
        return;
      }

      // Xử lý bankAccount
      BankAccount? parseBankAccount(dynamic rawBankAccount) {
        if (rawBankAccount is BankAccount) return rawBankAccount;
        if (rawBankAccount is Map<String, dynamic>) {
          return BankAccount.fromJson(rawBankAccount);
        }
        return null;
      }

      // Tạo instance Vehicle
      Vehicle vehicle;
      switch (data['type']?.toLowerCase()) {
        case 'car':
          vehicle = Car(
            id: '',
            vehicleId: '',
            vehicleName: data['vehicleName'] ?? '',
            licensePlate: data['licensePlate'] ?? '',
            brandId: data['brandId']?.toString() ?? '',
            model: data['model']?.toString() ?? 'none',
            yearOfManufacture: int.tryParse(data['yearOfManufacture']?.toString() ?? '') ?? 0,
            images: [],
            imagePublicIds: [],
            description: data['description']?.toString() ?? '',
            location: location,
            ownerId: user.userId,
            price: double.tryParse(data['price']?.toString() ?? '') ?? 0.0,
            bankAccount: parseBankAccount(data['bankAccount']),
            averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
            reviewCount: int.tryParse(data['reviewCount']?.toString() ?? '') ?? 0,
            available: data['available'] as bool? ?? true,
            deleted: data['deleted'] as bool? ?? false,
            status: data['status']?.toString() ?? 'pending',
            fuelType: data['fuelType']?.toString() ?? '',
            transmission: data['transmission']?.toString() ?? '',
            numberOfSeats: int.tryParse(data['numberOfSeats']?.toString() ?? '') ?? 0,  
          );
          break;
        case 'motor':
        case 'motorbike':
          vehicle = Motor(
            id: '',
            vehicleId: '',
            vehicleName: data['vehicleName'] ?? '',
            licensePlate: data['licensePlate'] ?? '',
            brandId: data['brandId']?.toString() ?? '',
            model: data['model']?.toString() ?? 'none',
            yearOfManufacture: int.tryParse(data['yearOfManufacture']?.toString() ?? '') ?? 0,
            images: [],
            imagePublicIds: [],
            description: data['description']?.toString() ?? '',
            location: location,
            ownerId: user.userId,
            price: double.tryParse(data['price']?.toString() ?? '') ?? 0.0,
            bankAccount: parseBankAccount(data['bankAccount']),
            averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
            reviewCount: int.tryParse(data['reviewCount']?.toString() ?? '') ?? 0,
            available: data['available'] as bool? ?? true,
            deleted: data['deleted'] as bool? ?? false,
            status: data['status']?.toString() ?? 'pending',
            fuelType: data['fuelType']?.toString() ?? '',
          );
          break;
        case 'coach':
          vehicle = Coach(
            id: '',
            vehicleId: '',
            vehicleName: data['vehicleName'] ?? '',
            licensePlate: data['licensePlate'] ?? '',
            brandId: data['brandId']?.toString() ?? '',
            model: data['model']?.toString() ?? 'none',
            yearOfManufacture: int.tryParse(data['yearOfManufacture']?.toString() ?? '') ?? 0,
            images: [],
            imagePublicIds: [],
            description: data['description']?.toString() ?? '',
            location: location,
            ownerId: user.userId,
            price: (data['price'] as num?)?.toDouble() ?? 0.0,
            bankAccount: parseBankAccount(data['bankAccount']),
            averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
            reviewCount: int.tryParse(data['reviewCount']?.toString() ?? '') ?? 0,
            available: data['available'] as bool? ?? true,
            deleted: data['deleted'] as bool? ?? false,
            status: data['status']?.toString() ?? 'pending',
            fuelType: data['fuelType']?.toString() ?? '',
            transmission: data['transmission']?.toString() ?? '',
            numberOfSeats: int.tryParse(data['numberOfSeats']?.toString() ?? '') ?? 0,  
          );
          break;
        case 'bike':
          vehicle = Bike(
            id: '',
            vehicleId: '',
            vehicleName: data['vehicleName'] ?? '',
            licensePlate: data['licensePlate'] ?? '',
            brandId: data['brandId']?.toString() ?? '',
            model: data['model']?.toString() ?? 'none',
            yearOfManufacture: int.tryParse(data['yearOfManufacture']?.toString() ?? '') ?? 0,
            images: [],
            imagePublicIds: [],
            description: data['description']?.toString() ?? '',
            location: location,
            ownerId: user.userId,
            price: double.tryParse(data['price']?.toString() ?? '') ?? 0.0,
            bankAccount: parseBankAccount(data['bankAccount']),
            averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
            reviewCount: int.tryParse(data['reviewCount']?.toString() ?? '') ?? 0,
            available: data['available'] as bool? ?? true,
            deleted: data['deleted'] as bool? ?? false,
            status: data['status']?.toString() ?? 'pending',
            typeOfBike: data['typeOfBike']?.toString() ?? '',
          );
          break;
        default:
          debugPrint('❌ Unknown vehicle type: ${data['type']}');
          _handleAuthError('Loại xe không hợp lệ', context);
          return;
      }

      final response = await VehicleApi.createVehicle(
        this,
        authService: authService,
        vehicle: vehicle,
        imageFiles: imageFiles,
      );

      if (response.success && response.data != null) {
        _vehicles.insert(0, response.data!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.message ?? 'Tạo xe ${data['type']} thành công!',
            ),
          ),
        );
      } else {
        _handleAuthError(
          response.message ?? 'Tạo xe thất bại',
          context,
        );
      }
    } catch (e) {
      debugPrint('❌ Error creating vehicle: $e');
      _handleAuthError('Lỗi khi tạo xe: $e', context);
    } finally {
      _isLoadingVehicles = false;
      notifyListeners();
    }
  }

  Future<void> updateVehicle(
    BuildContext context, {
    required String vehicleId,
    required Map<String, dynamic> data,
    List<File>? imageFiles,
  }) async {
    _isLoadingVehicles = true;
    notifyListeners();

    try {
      debugPrint('🚀 Updating vehicle with ID: $vehicleId, data: $data');
      debugPrint('📎 Files: ${imageFiles?.map((f) => f.path).toList() ?? []}');

      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      final user = userViewModel.user;
      if (user == null) {
        debugPrint('❌ No user found');
        _handleAuthError('Vui lòng đăng nhập lại', context);
        return;
      }

      // Kiểm tra các trường bắt buộc
      if (data['vehicleName'] == null || data['vehicleName'].toString().isEmpty) {
        debugPrint('❌ VehicleName is empty');
        _handleAuthError('Tên xe không được để trống', context);
        return;
      }
      if (data['licensePlate'] == null || data['licensePlate'].toString().isEmpty) {
        debugPrint('❌ LicensePlate is empty');
        _handleAuthError('Biển số xe không được để trống', context);
        return;
      }
      if (data['brandId'] == null || data['brandId'].toString().isEmpty) {
        debugPrint('❌ BrandId is empty');
        _handleAuthError('Thương hiệu không được để trống', context);
        return;
      }
      if (data['type'] == null || data['type'].toString().isEmpty) {
        debugPrint('❌ Type is empty');
        _handleAuthError('Loại xe không được để trống', context);
        return;
      }

      // Xử lý location
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

      // Xử lý bankAccount
      BankAccount? parseBankAccount(dynamic rawBankAccount) {
        if (rawBankAccount is BankAccount) return rawBankAccount;
        if (rawBankAccount is Map<String, dynamic>) {
          return BankAccount.fromJson(rawBankAccount);
        }
        return null;
      }

      // Tạo instance Vehicle
      Vehicle vehicle;
      switch (data['type']?.toLowerCase()) {
        case 'car':
          vehicle = Car(
            id: vehicleId,
            vehicleId: vehicleId,
            vehicleName: data['vehicleName'] ?? '',
            licensePlate: data['licensePlate'] ?? '',
            brandId: data['brandId']?.toString() ?? '',
            model: data['model']?.toString() ?? 'none',
            yearOfManufacture: int.tryParse(data['yearOfManufacture']?.toString() ?? '') ?? 0,
            images: [],
            imagePublicIds: [],
            description: data['description']?.toString() ?? '',
            location: location,
            ownerId: user.userId,
            price: double.tryParse(data['price']?.toString() ?? '') ?? 0.0,
            bankAccount: parseBankAccount(data['bankAccount']),
            averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
            reviewCount: int.tryParse(data['reviewCount']?.toString() ?? '') ?? 0,
            available: data['available'] as bool? ?? true,
            deleted: data['deleted'] as bool? ?? false,
            status: data['status']?.toString() ?? 'pending',
            fuelType: data['fuelType']?.toString() ?? '',
            transmission: data['transmission']?.toString() ?? '',
            numberOfSeats: int.tryParse(data['numberOfSeats']?.toString() ?? '') ?? 0,  
          );
          break;
        case 'motor':
        case 'motorbike':
          vehicle = Motor(
            id: vehicleId,
            vehicleId: vehicleId,
            vehicleName: data['vehicleName'] ?? '',
            licensePlate: data['licensePlate'] ?? '',
            brandId: data['brandId']?.toString() ?? '',
            model: data['model']?.toString() ?? 'none',
            yearOfManufacture: int.tryParse(data['yearOfManufacture']?.toString() ?? '') ?? 0,
            images: [],
            imagePublicIds: [],
            description: data['description']?.toString() ?? '',
            location: location,
            ownerId: user.userId,
            price: double.tryParse(data['price']?.toString() ?? '') ?? 0.0,
            bankAccount: parseBankAccount(data['bankAccount']),
            averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
            reviewCount: int.tryParse(data['reviewCount']?.toString() ?? '') ?? 0,
            available: data['available'] as bool? ?? true,
            deleted: data['deleted'] as bool? ?? false,
            status: data['status']?.toString() ?? 'pending',
            fuelType: data['fuelType']?.toString() ?? '',
          );
          break;
        case 'coach':
          vehicle = Coach(
            id: vehicleId,
            vehicleId: vehicleId,
            vehicleName: data['vehicleName'] ?? '',
            licensePlate: data['licensePlate'] ?? '',
            brandId: data['brandId']?.toString() ?? '',
            model: data['model']?.toString() ?? 'none',
            yearOfManufacture: int.tryParse(data['yearOfManufacture']?.toString() ?? '') ?? 0,
            images: [],
            imagePublicIds: [],
            description: data['description']?.toString() ?? '',
            location: location,
            ownerId: user.userId,
            price: double.tryParse(data['price']?.toString() ?? '') ?? 0.0,
            bankAccount: parseBankAccount(data['bankAccount']),
            averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
            reviewCount: int.tryParse(data['reviewCount']?.toString() ?? '') ?? 0,
            available: data['available'] as bool? ?? true,
            deleted: data['deleted'] as bool? ?? false,
            status: data['status']?.toString() ?? 'pending',
            fuelType: data['fuelType']?.toString() ?? '',
            transmission: data['transmission']?.toString() ?? '',
            numberOfSeats: int.tryParse(data['numberOfSeats']?.toString() ?? '') ?? 0,  
          );
          break;
        case 'bike':
          vehicle = Bike(
            id: vehicleId,
            vehicleId: vehicleId,
            vehicleName: data['vehicleName'] ?? '',
            licensePlate: data['licensePlate'] ?? '',
            brandId: data['brandId']?.toString() ?? '',
            model: data['model']?.toString() ?? 'none',
            yearOfManufacture: int.tryParse(data['yearOfManufacture']?.toString() ?? '') ?? 0,
            images: [],
            imagePublicIds: [],
            description: data['description']?.toString() ?? '',
            location: location,
            ownerId: user.userId,
            price: double.tryParse(data['price']?.toString() ?? '') ?? 0.0,
            bankAccount: parseBankAccount(data['bankAccount']),
            averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
            reviewCount: int.tryParse(data['reviewCount']?.toString() ?? '') ?? 0,
            available: data['available'] as bool? ?? true,
            deleted: data['deleted'] as bool? ?? false,
            status: data['status']?.toString() ?? 'pending',
            typeOfBike: data['typeOfBike']?.toString() ?? '',
          );
          break;
        default:
          debugPrint('❌ Unknown vehicle type: ${data['type']}');
          _handleAuthError('Loại xe không hợp lệ', context);
          return;
      }

      final response = await VehicleApi.updateVehicle(
        this,
        authService: authService,
        vehicleId: vehicleId,
        vehicle: vehicle,
        images: imageFiles,
      );

      if (response.success && response.data != null) {
        final index = _vehicles.indexWhere((v) => v.id == vehicleId);
        if (index != -1) {
          _vehicles[index] = response.data!;
        } else {
          _vehicles.add(response.data!);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Cập nhật xe thành công!'),
          ),
        );
      } else {
        _handleAuthError(
          response.message ?? 'Cập nhật xe thất bại',
          context,
        );
      }
    } catch (e) {
      debugPrint('❌ Error updating vehicle: $e');
      _handleAuthError('Lỗi khi cập nhật xe: $e', context);
    } finally {
      _isLoadingVehicles = false;
      notifyListeners();
    }
  }

  Future<bool> deleteVehicleById(
    BuildContext context, {
    required String vehicleId,
  }) async {
    final response = await VehicleApi.deleteVehicle(
      this,
      authService: authService,
      vehicleId: vehicleId,
    );

    if (response.success) {
      // chỉ xoá nếu tìm thấy trong list
      final beforeLength = _vehicles.length;
      _vehicles.removeWhere((v) => v.id == vehicleId);

      if (_vehicles.length != beforeLength) {
        notifyListeners(); // chỉ notify khi có thay đổi thực sự
      }

      return true;
    } else {
      // xử lý lỗi (auth hoặc message từ server)
      _handleAuthError(response.message, context);
      return false;
    }
  }
}