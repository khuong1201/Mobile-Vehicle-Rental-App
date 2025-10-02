import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/api_services/user/get_user_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/api_services/user/update_profile.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
import 'package:intl/intl.dart';

class PersonalInfoViewModel extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String? name;
  String? dateOfBirth;
  String? phoneNumber;
  String? gender;
  List<String>? nationalIdNumber;

  String? classLicense;
  String? typeDriverLicense;
  String? licenseNumber;
  XFile? frontImage;
  XFile? backImage;

  Future<void> _saveToStorage() async {
    await _secureStorage.write(
      key: 'user',
      value: jsonEncode({
        'name': name,
        'dateOfBirth': dateOfBirth,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'nationalIdNumber': nationalIdNumber,
        'classLicense': classLicense,
        'typeDriverLicense': typeDriverLicense,
        'licenseNumber': licenseNumber,
        'frontImagePath': frontImage?.path,
        'backImagePath': backImage?.path,
      }),
    );
  }

  Future<void> loadFromStorage() async {
    final dataString = await _secureStorage.read(key: 'user');
    if (dataString == null) return;
    final Map<String, dynamic> data = jsonDecode(dataString);

    name = data['name'];
    dateOfBirth = data['dateOfBirth'];
    phoneNumber = data['phoneNumber'];
    gender = data['gender'];
    nationalIdNumber =
        data['nationalIdNumber'] != null
            ? List<String>.from(data['nationalIdNumber'])
            : null;

    classLicense = data['classLicense'];
    typeDriverLicense = data['typeDriverLicense'];
    licenseNumber = data['licenseNumber'];
    final frontPath = data['frontImagePath'];
    final backPath = data['backImagePath'];
    if (frontPath != null) frontImage = XFile(frontPath);
    if (backPath != null) backImage = XFile(backPath);

    notifyListeners();
  }

  Future<void> clear() async {
    await _secureStorage.delete(key: 'user');
    name = null;
    dateOfBirth = null;
    phoneNumber = null;
    gender = null;
    nationalIdNumber = null;
    classLicense = null;
    typeDriverLicense = null;
    licenseNumber = null;
    frontImage = null;
    backImage = null;
    notifyListeners();
  }

  Future<void> loadFromBackend(AuthService authService) async {
    final response = await getUserProfileApi(
      viewModel: this,
      authService: authService,
    );

    if (response.success && response.data != null) {
      final user = response.data!;
      name = user['fullName'];
      if (user['dateOfBirth'] != null && user['dateOfBirth'].isNotEmpty) {
        try {
          final date = DateTime.parse(user['dateOfBirth']);
          dateOfBirth = DateFormat('dd/MM/yyyy').format(date);
        } catch (_) {
          dateOfBirth = '';
        }
      }
      phoneNumber = user['phoneNumber'];
      gender = user['gender'];
      nationalIdNumber = (user['nationalIdNumber'] as List?)?.cast<String>();

      await _saveToStorage();
      notifyListeners();
    }
  }

  Future<ApiResponse<dynamic>> updateToServer(AuthService authService) async {
    if (name == null ||
        dateOfBirth == null ||
        phoneNumber == null ||
        gender == null ||
        nationalIdNumber == null) {
      return ApiResponse(success: false, message: 'Missing required fields');
    }

    final response = await updatePersonalInfoApi(
      viewModel: this,
      authService: authService,
      fullName: name!,
      dateOfBirth: dateOfBirth!,
      phoneNumber: phoneNumber!,
      gender: gender!,
      nationalIdNumber: nationalIdNumber!,
    );

    if (response.success) {
      await _saveToStorage();
      notifyListeners();
    }

    return response;
  }

  Future<void> setInformation({
    String? name,
    String? dateOfBirth,
    String? phoneNumber,
    String? gender,
    List<String>? nationalIdNumber,
    String? classLicense,
    String? typeDriverLicense,
    String? licenseNumber,
    XFile? frontImage,
    XFile? backImage,
  }) async {
    this.name = name ?? this.name;
    this.dateOfBirth = dateOfBirth ?? this.dateOfBirth;
    this.phoneNumber = phoneNumber ?? this.phoneNumber;
    this.gender = gender ?? this.gender;
    this.nationalIdNumber = nationalIdNumber ?? this.nationalIdNumber;
    this.classLicense = classLicense ?? this.classLicense;
    this.typeDriverLicense = typeDriverLicense ?? this.typeDriverLicense;
    this.licenseNumber = licenseNumber ?? this.licenseNumber;
    this.frontImage = frontImage ?? this.frontImage;
    this.backImage = backImage ?? this.backImage;

    await _saveToStorage();
    notifyListeners();
  }
}
