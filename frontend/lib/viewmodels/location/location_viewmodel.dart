import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:frontend/api_services/location/location_api.dart';
import 'package:frontend/models/location/district.dart';
import 'package:frontend/models/location/location.dart';
import 'package:frontend/models/location/province.dart';
import 'package:frontend/models/location/ward.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationViewModel with ChangeNotifier {
  List<Province> _allProvinces = [];
  List<Province> _filteredProvinces = [];
  List<District> _districts = [];
  List<Ward> _wards = [];

  Province? selectedProvince;
  District? selectedDistrict;
  Ward? selectedWard;

  bool _isLoadingProvinces = false;
  bool _isLoadingDistricts = false;
  bool _isLoadingWards = false;
  String? _errorMessage;

  // Lưu provinceCode và districtCode
  String? _currentProvinceCode;
  String? _currentDistrictCode;

  List<Province> get provinces => _filteredProvinces;
  List<District> get districts => _districts;
  List<Ward> get wards => _wards;

  bool get isLoadingProvinces => _isLoadingProvinces;
  bool get isLoadingDistricts => _isLoadingDistricts;
  bool get isLoadingWards => _isLoadingWards;
  String? get errorMessage => _errorMessage;

  String? get currentProvinceCode => _currentProvinceCode;
  String? get currentDistrictCode => _currentDistrictCode;

  Future<void> fetchProvinces() async {
    _setLoadingProvinces(true);
    try {
      final response = await LocationApi.getAllProvinces();
      if (response.success && response.data != null) {
        _allProvinces = response.data!;
        _filteredProvinces = List.from(_allProvinces);
        _errorMessage = null;
      } else {
        _allProvinces = [];
        _filteredProvinces = List.from(_allProvinces);
        _errorMessage = response.message ?? 'Không tìm thấy tỉnh/thành phố nào';
      }
    } catch (e) {
      _errorMessage = 'Lỗi khi lấy tỉnh/thành: $e';
      if (kDebugMode) print(_errorMessage);
    } finally {
      _setLoadingProvinces(false);
    }
  }

  void searchProvinces(String query) {
    if (query.isEmpty) {
      _filteredProvinces = List.from(_allProvinces);
    } else {
      _filteredProvinces = _allProvinces
          .where((province) => province.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> selectProvince(Province province) async {
    selectedProvince = province;
    selectedDistrict = null;
    selectedWard = null;
    _districts = [];
    _wards = [];
    _currentProvinceCode = province.code; // Lưu provinceCode khi chọn tỉnh
    _currentDistrictCode = null;

    _setLoadingDistricts(true);
    try {
      final provinceCode = int.tryParse(province.code) ?? 0;
      print('Fetching districts for provinceCode: $provinceCode, Province.code: ${province.code}');
      final res = await LocationApi.postDistrictsByProvince(provinceCode);
      if (res.success && res.data != null) {
        _districts = res.data!;
        _errorMessage = null;
      } else {
        _districts = [];
        _errorMessage = res.message ?? 'Không tìm thấy quận/huyện nào';
      }
    } catch (e) {
      _errorMessage = 'Lỗi khi lấy quận/huyện: $e';
      if (kDebugMode) print(_errorMessage);
    } finally {
      _setLoadingDistricts(false);
    }
  }

  Future<void> selectDistrict(District district) async {
    selectedDistrict = district;
    selectedWard = null;
    _wards = [];
    _currentDistrictCode = district.code; // Lưu districtCode khi chọn quận

    _setLoadingWards(true);
    try {
      final districtCode = int.tryParse(district.code) ?? 0;
      print('Fetching wards for districtCode: $districtCode, District.code: ${district.code}');
      final res = await LocationApi.postWardsByDistrict(districtCode);
      if (res.success && res.data != null) {
        _wards = res.data!;
        _errorMessage = null;
      } else {
        _wards = [];
        _errorMessage = res.message ?? 'Không tìm thấy phường/xã nào';
      }
    } catch (e) { 
      _errorMessage = 'Lỗi khi lấy phường/xã: $e';
      if (kDebugMode) print(_errorMessage);
    } finally {
      _setLoadingWards(false);
    }
  }

  void selectWard(Ward ward) {
    selectedWard = ward;
    notifyListeners();
  }

  Locations getFullLocation() {
    return Locations(
      province: selectedProvince!,
      district: selectedDistrict!,
      ward: selectedWard!,
    );
  }

  void reset() {
    _allProvinces = [];
    _filteredProvinces = [];
    _districts = [];
    _wards = [];
    selectedProvince = null;
    selectedDistrict = null;
    selectedWard = null;
    _currentProvinceCode = null;
    _currentDistrictCode = null;
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

  void _setLoadingDistricts(bool value) {
    _isLoadingDistricts = value;
    notifyListeners();
  }

  void _setLoadingWards(bool value) {
    _isLoadingWards = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Dịch vụ vị trí chưa được bật');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Bạn đã từ chối quyền truy cập vị trí');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Quyền vị trí bị từ chối vĩnh viễn');
    }

    return await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<Placemark?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      return placemarks.isNotEmpty ? placemarks.first : null;
    } catch (e) {
      print('Lỗi khi lấy địa chỉ từ tọa độ: $e');
      return null;
    }
  }

  Future<void> autoSelectLocationFromCoordinates(double lat, double lng) async {
    try {
      final place = await getAddressFromCoordinates(lat, lng);
      if (place == null) return;

      final provinceName = place.administrativeArea ?? '';
      final districtName = place.subAdministrativeArea ?? '';
      final wardName = place.locality ?? '';

      selectedProvince = _allProvinces.firstWhere(
        (p) => p.name == provinceName,
        orElse: () => _allProvinces.first,
      );
      notifyListeners();

      await selectProvince(selectedProvince!);

      selectedDistrict = _districts.firstWhere(
        (d) => d.name == districtName,
        orElse: () => _districts.first,
      );
      notifyListeners();

      await selectDistrict(selectedDistrict!);

      selectedWard = _wards.firstWhere(
        (w) => w.name == wardName,
        orElse: () => _wards.first,
      );
      notifyListeners();
    } catch (e) {
      print('Không thể tự động xác định vị trí: $e');
    }
  }
}