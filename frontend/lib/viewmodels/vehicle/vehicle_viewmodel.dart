import 'package:flutter/material.dart';
import 'package:frontend/api_services/vehicle/api_get_brand.dart';
import 'package:frontend/api_services/vehicle/get_vehicle.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

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

  void changeVehicleType(String? type, BuildContext context) {
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

    final response = await ApiGetAllVehicle.getAllVehicle(
      this,
      authService: authService,
      page: page,
      limit: limit,
      type: type,
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
    debugPrint('Error: $_errorMessage');
    if (message?.contains('Token refresh failed') == true ||
        message?.contains('Invalid or expired token') == true) {
      final logoutSuccess = await authService.logout();
      if (logoutSuccess && context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }
}
