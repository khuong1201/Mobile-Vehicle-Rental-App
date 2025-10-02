import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/user/get_user_profile.dart';
import 'package:frontend/api_services/user/license_api.dart';
import 'package:frontend/models/user/userLicense.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class UserLicenseViewModel extends ChangeNotifier {
  final AuthService authService;

  UserLicense? userLicense;
  List<UserLicense> licenses = [];
  bool isLoading = false;
  String? errorMessage;
  ApiResponse? lastResponse;

  UserLicenseViewModel({required this.authService});

  void _setLoading(bool value) {
    if (isLoading != value) {
      isLoading = value;
      notifyListeners();
    }
  }

  Future<bool> createDriverLicense({
    required String typeOfDriverLicense,
    required String classLicense,
    required String licenseNumber,
    required File frontImage,
    required File backImage,
  }) async {
    _setLoading(true);
    errorMessage = null;

    try {
      final response = await DriverLicenseApi.create(
        viewModel: this,
        authService: authService,
        typeOfDriverLicense: typeOfDriverLicense,
        classLicense: classLicense,
        licenseNumber: licenseNumber,
        frontImage: frontImage,
        backImage: backImage,
      );

      lastResponse = response;

      if (response.success) {
        await loadUserLicenseFromProfile();
        return true;
      } else {
        errorMessage = response.message ?? 'Failed to create license';
        return false;
      }
    } catch (e) {
      errorMessage = 'Unexpected error: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateDriverLicense({
    required String typeOfDriverLicense,
    required String classLicense,
    required String licenseNumber,
    File? frontImage,
    File? backImage,
  }) async {
    _setLoading(true);
    errorMessage = null;

    try {
      final response = await DriverLicenseApi.update(
        viewModel: this,
        authService: authService,
        typeOfDriverLicense: typeOfDriverLicense,
        classLicense: classLicense,
        licenseNumber: licenseNumber,
        frontImage: frontImage,
        backImage: backImage,
      );

      lastResponse = response;

      if (response.success) {
        await loadUserLicenseFromProfile();
        return true;
      } else {
        errorMessage = response.message ?? 'Failed to update license';
        return false;
      }
    } catch (e) {
      errorMessage = 'Unexpected error: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteDriverLicense({required String licenseId}) async {
    _setLoading(true);
    errorMessage = null;

    try {
      final response = await DriverLicenseApi.delete(
        viewModel: this,
        authService: authService,
        licenseId: licenseId,
      );

      lastResponse = response;

      if (response.success) {
        await loadUserLicenseFromProfile();
        return true;
      } else {
        errorMessage = response.message ?? 'Failed to delete license';
        return false;
      }
    } catch (e) {
      errorMessage = 'Unexpected error: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadUserLicenseFromProfile() async {
    _setLoading(true);
    errorMessage = null;

    try {
      final response = await getUserProfileApi(
        viewModel: this,
        authService: authService,
      );

      lastResponse = response;

      if (response.success && response.data != null) {
        final userData = response.data;
        final licenseList = userData['license'] as List?;

        if (licenseList != null && licenseList.isNotEmpty) {
          licenses = licenseList.map((json) => UserLicense.fromJson(json)).toList();
          userLicense = licenses.first;
        } else {
          licenses = [];
          userLicense = null;
        }
      } else {
        errorMessage = response.message ?? 'Failed to load user data';
        licenses = [];
        userLicense = null;
      }
    } catch (e) {
      errorMessage = 'Unexpected error: $e';
      licenses = [];
      userLicense = null;
    } finally {
      _setLoading(false);
    }
  }
}
