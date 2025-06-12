import 'package:flutter/material.dart';
import 'package:frontend/api_services/get_vehicle.dart';
import '../models/vehicle.dart';

class VehicleViewModel extends ChangeNotifier {
  List<Vehicle> _vehicles = [];

  Future<void> fetchVehicles() async {
    _vehicles = await GetVehicleService.fetchVehiclesFromBackend();
    notifyListeners();
  }

  List<Vehicle> get vehicles => _vehicles;

  Vehicle? getVehicleById(int id) {
    try {
      return _vehicles.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }
}