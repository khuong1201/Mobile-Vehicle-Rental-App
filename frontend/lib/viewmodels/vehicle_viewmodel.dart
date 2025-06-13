import 'package:flutter/material.dart';
import 'package:frontend/api_services/get_vehicle.dart';
import 'package:frontend/models/vehicles/vehicle.dart';

class VehicleViewModel extends ChangeNotifier {
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchVehicles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await ApiGetAllVehicle.getAllVehicle(this);

    if (response.success) {
      _vehicles = response.data ?? [];
    } else {
      _errorMessage = response.message;
    }

    _isLoading = false;
    notifyListeners();
  }

  void refresh() {
    fetchVehicles();
  }
}
