import 'package:flutter/material.dart';
import 'package:frontend/models/location/location_for_vehicle.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationViewModel extends ChangeNotifier {
  String _currentAddress = "Unknown location";
  Position? _currentPosition;
  bool _isLoading = false;

  String get currentAddress => _currentAddress;
  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;

  /// Lấy vị trí hiện tại và reverse geocoding
  Future<void> fetchCurrentLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Kiểm tra quyền
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _currentAddress = 'Location services are disabled.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _currentAddress = 'Location permissions are denied';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _currentAddress =
            'Location permissions are permanently denied, cannot request.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Lấy vị trí hiện tại
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _currentAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
      } else {
        _currentAddress = "Unknown location";
      }
    } catch (e) {
      _currentAddress = "Error: $e";
    }

    _isLoading = false;
    notifyListeners();
  }
  
  Future<LocationForVehicle?> fetchCurrentLocationForVehicle() async {
  try {
    await fetchCurrentLocation();

    if (_currentPosition == null) return null;

    final addressComponents = [
      _currentAddress,
    ].where((e) => e.isNotEmpty).join(', ');

    return LocationForVehicle(
      type: "Point",
      coordinates: [_currentPosition!.longitude, _currentPosition!.latitude],
      address: addressComponents.isNotEmpty ? addressComponents : "Unknown location",
    );
  } catch (_) {
    return null;
  }
}
}
