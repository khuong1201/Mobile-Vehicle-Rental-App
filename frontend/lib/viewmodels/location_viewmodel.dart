import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:frontend/api_services/location/location_api.dart';

class LocationViewModel with ChangeNotifier {
  List<dynamic> _allProvinces = [];       // full từ API
  List<dynamic> _filteredProvinces = [];  // danh sách được lọc theo search
  bool _isLoadingProvinces = false;
  String? _errorMessage;

  List<dynamic> get provinces => _filteredProvinces;
  bool get isLoadingProvinces => _isLoadingProvinces;
  String? get errorMessage => _errorMessage;

  /// Gọi API lấy danh sách tỉnh/thành
  Future<void> fetchProvinces() async {
    _setLoading(true);
    try {
      final response = await LocationApi.getAllProvinces();
      if (response.success && response.data != null) {
        _allProvinces = response.data!;
        _filteredProvinces = List.from(_allProvinces);
        _errorMessage = null;
      } else {
        _allProvinces = [];
        _filteredProvinces = [];
        _errorMessage = response.message ?? 'Không tìm thấy tỉnh/thành phố nào';
      }
    } catch (e) {
      _allProvinces = [];
      _filteredProvinces = [];
      _errorMessage = 'Lỗi khi lấy tỉnh/thành: $e';
      if (kDebugMode) print(_errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  /// Lọc tỉnh/thành theo từ khóa tìm kiếm
  void searchProvinces(String query) {
    if (query.isEmpty) {
      _filteredProvinces = List.from(_allProvinces);
    } else {
      _filteredProvinces = _allProvinces.where((province) {
        final name = (province['name'] ?? '').toLowerCase();
        return name.contains(query.trim().toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoadingProvinces = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _allProvinces = [];
    _filteredProvinces = [];
    _isLoadingProvinces = false;
    _errorMessage = null;
    notifyListeners();
  }
}
