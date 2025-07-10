import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/api_services/user/create_license.dart';
import 'package:frontend/api_services/user/delete_license.dart';
import 'package:frontend/api_services/user/get_user_profile.dart';
import 'package:frontend/api_services/user/update_license.dart';
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

  Future<bool> createDriverLicense({
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
      final response = await createDriverLicenseApi(
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
        await loadUserLicenseFromProfile();
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


  Future<bool> updateDriverLicense({
    required String typeOfDriverLicense,
    required String classLicense,
    required String licenseNumber,
    File? frontImage,
    File? backImage,
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
        frontImage: frontImage,
        backImage: backImage,
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
  
  Future<bool> deleteDriverLicense({
    required String licenseId,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await deleteDriverLicenseApi(
        viewModel: this,
        authService: authService,
        licenseId: licenseId,
      );

      lastResponse = response;

      if (response.success) {
        await loadUserLicenseFromProfile(); // Cập nhật danh sách mới
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

  Future<void> loadUserLicenseFromProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await getUserProfileApi(
        viewModel: this,
        authService: authService,
      );

      if (response.success && response.data != null) {
        final userData = response.data;
        final licenseList = userData['license'] as List?;
        debugPrint("📋 License data: $licenseList");
        if (licenseList != null && licenseList.isNotEmpty) {
          // ✅ Gán danh sách
          licenses = licenseList.map((json) => UserLicense.fromJson(json)).toList();

          // ✅ Gán bằng lái đầu tiên nếu cần
          userLicense = licenses.first;

          debugPrint("✅ License loaded: ${userLicense?.licenseNumber}");
          debugPrint("📋 Tổng số license: ${licenses.length}");
        } else {
          debugPrint("⚠️ No license found in response");
          userLicense = null;
          licenses = [];
        }
      } else {
        errorMessage = response.message;
        userLicense = null;
        licenses = [];
      }
    } catch (e) {
      errorMessage = 'Unexpected error: $e';
      userLicense = null;
      licenses = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
