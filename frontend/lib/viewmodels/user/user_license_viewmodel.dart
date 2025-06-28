import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/user/update_license.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class UserLicenseViewModel extends ChangeNotifier {
  final AuthService authService;
  bool isLoading = false;
  String? errorMessage;
  ApiResponse? lastResponse;

  UserLicenseViewModel({required this.authService});

  Future<bool> updateDriverLicense({
    required String typeOfDriverLicense,
    required String classLicense,
    required String licenseNumber,
    required File frontImage,
    required File backImage,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await updateDriverLicenseApi(
        viewModel: this,
        authService: authService,
        typeOfDriverLicense: typeOfDriverLicense,
        classLicense: classLicense,
        licenseNumber: licenseNumber,
        frontImage: File(frontImage.path),
        backImage: File(backImage.path),
      );

      lastResponse = response;

      if (response.success) {
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = response.message;
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'Unexpected error: $e';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
