import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInfoViewModel extends ChangeNotifier {
  String? name;
  String? dateOfBirth;
  String? phoneNumber;
  String? gender;
  String? ids;

  String? classLicense;
  String? typeDriverLicense;
  String? licenseNumber;
  XFile? frontImage;
  XFile? backImage;

  void setInformation({
    String? name,
    String? dateOfBirth,
    String? phoneNumber,
    String? gender,
    String? ids,

    String? className,
    String? typeDriverLicense,
  }) {
    this.name = name;
    this.dateOfBirth = dateOfBirth;
    this.phoneNumber = phoneNumber;
    this.gender = gender;
    this.ids = ids;

    classLicense = classLicense;
    this.typeDriverLicense = typeDriverLicense;
    notifyListeners();
  }

  void clear() {
    name = null;
    dateOfBirth = null;
    phoneNumber = null;
    gender = null;
    ids = null;
    classLicense = null;
    typeDriverLicense = null;
    licenseNumber = null;
    frontImage = null;
    backImage = null;
    notifyListeners();
  }
}
