import 'package:flutter/material.dart';
import 'package:frontend/api_services/brand/api_get_brand.dart';
import 'package:frontend/api_services/auth/get_vehicle.dart';

import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class VehicleViewModel extends ChangeNotifier {
  final AuthService authService;
  final List<Vehicle> _vehicles = [];
  final List<Brand> _brands = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;

  List<Vehicle> get vehicles => _vehicles;
  List<Brand> get brands => _brands;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;

  VehicleViewModel(this.authService);

  Future<void> fetchVehicles(
    BuildContext context, {
    bool loadMore = false,
  }) async {
    if (_isLoading || (!loadMore && _vehicles.isNotEmpty)) return;

    _isLoading = true;
    if (!loadMore) {
      _currentPage = 1;
      _vehicles.clear();
    }
    notifyListeners();

    final response = await ApiGetAllVehicle.getAllVehicle(
      this,
      authService: authService,
      page: _currentPage,
      limit: 20,
    );

    if (response.success) {
      _vehicles.addAll(response.data ?? []);
      _hasMore = (response.data?.length ?? 0) == 20;
      _currentPage++;
    } else {
      _errorMessage = response.message;
      debugPrint('Failed to fetch vehicles: $_errorMessage');
      if (_errorMessage?.contains('Token refresh failed') ??
          false || _errorMessage!.contains('Invalid or expired token')) {
        final logoutSuccess = await authService.logout();
        if (logoutSuccess && context.mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchBrands(BuildContext context) async {
    if (_isLoading) return;

    _isLoading = true;
    _brands.clear();
    notifyListeners();

    final response = await ApiGetAllBrand.getAllBrand(
      this,
      authService: authService,
    );

    if (response.success) {
      _brands.addAll(response.data ?? []);
    } else {
      _errorMessage = response.message;
      debugPrint('Failed to fetch brands: $_errorMessage');
      if (_errorMessage?.contains('Token refresh failed') ??
          false || _errorMessage!.contains('Invalid or expired token')) {
        final logoutSuccess = await authService.logout();
        if (logoutSuccess && context.mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    final logoutSuccess = await authService.logout();
    if (logoutSuccess && context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void refresh(BuildContext context) {
    fetchVehicles(context);
    fetchBrands(context);
  }
}
