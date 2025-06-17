import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:http/http.dart' as http;

class BrandViewModel with ChangeNotifier {
  List<Brand> _brands = [];
  bool _isLoading = false;
  String? _error;

  List<Brand> get brands => _brands;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBrands() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('http://your-backend-url/api/brands'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _brands = data.map((json) => Brand.fromJson(json)).toList();
      } else {
        _error = 'Failed to load brands';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}