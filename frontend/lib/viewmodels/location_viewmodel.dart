import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:frontend/api_services/location/location_api.dart';

class LocationViewModel with ChangeNotifier {
  // --- Province ---
  List<dynamic> _allProvinces = [];
  List<dynamic> _filteredProvinces = [];
  bool _isLoadingProvinces = false;

  // --- District ---
  List<dynamic> _districts = [];
  bool _isLoadingDistricts = false;

  // --- Ward ---
  List<dynamic> _wards = [];
  bool _isLoadingWards = false;

  // --- Error ---
  String? _errorMessage;

  // --- Getters ---
  List<dynamic> get provinces => _filteredProvinces;
  List<dynamic> get districts => _districts;
  List<dynamic> get wards => _wards;

  bool get isLoadingProvinces => _isLoadingProvinces;
  bool get isLoadingDistricts => _isLoadingDistricts;
  bool get isLoadingWards => _isLoadingWards;
  String? get errorMessage => _errorMessage;

  // --- Provinces ---
  Future<void> fetchProvinces() async {
    _setLoadingProvinces(true);
    try {
      final response = await LocationApi.getAllProvinces();
      if (response.success && response.data != null) {
        _allProvinces = response.data!;
        _filteredProvinces = List.from(_allProvinces);
        _errorMessage = null;
      } else {
        _allProvinces.clear();
        _filteredProvinces.clear();
        _errorMessage = response.message ?? 'Không tìm thấy tỉnh/thành phố nào';
      }
    } catch (e) {
      _errorMessage = 'Lỗi khi lấy tỉnh/thành: $e';
      _allProvinces.clear();
      _filteredProvinces.clear();
      if (kDebugMode) print(_errorMessage);
    } finally {
      _setLoadingProvinces(false);
    }
  }

  void searchProvinces(String query) {
    _filteredProvinces = query.isEmpty
        ? List.from(_allProvinces)
        : _allProvinces.where((province) {
            final name = (province['name'] ?? '').toLowerCase();
            return name.contains(query.trim().toLowerCase());
          }).toList();
    notifyListeners();
  }

  // --- Districts ---
  Future<void> fetchDistricts(int provinceCode) async {
    _isLoadingDistricts = true;
    _districts.clear();
    notifyListeners();

    final response = await LocationApi.getDistrictsByProvince(provinceCode);
    if (response.success && response.data != null) {
      _districts = response.data!;
    }

    _isLoadingDistricts = false;
    notifyListeners();
  }

  // --- Wards ---
  Future<void> fetchWards(int districtCode) async {
    _isLoadingWards = true;
    _wards.clear();
    notifyListeners();

    final response = await LocationApi.getWardsByDistrict(districtCode);
    if (response.success && response.data != null) {
      _wards = response.data!;
    }

    _isLoadingWards = false;
    notifyListeners();
  }

  // --- Reset ---
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _allProvinces.clear();
    _filteredProvinces.clear();
    _districts.clear();
    _wards.clear();
    _isLoadingProvinces = false;
    _isLoadingDistricts = false;
    _isLoadingWards = false;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoadingProvinces(bool value) {
    _isLoadingProvinces = value;
    notifyListeners();
  }
}
