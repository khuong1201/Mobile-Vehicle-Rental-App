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
  ImagePicker _picker = ImagePicker();
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

    this.classLicense = classLicense;
    this.typeDriverLicense = typeDriverLicense;
    notifyListeners();
  }

  Future<void> pickFrontImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      frontImage = image;
      notifyListeners();
    }
  }

  Future<void> pickBackImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      backImage = image;
      notifyListeners();
    }
  }

  void clear() {
    name = null;
    dateOfBirth = null;
    phoneNumber = null;
    gender = null;
    ids = null;
    classLicense = null;
    frontImage = null;
    backImage = null;
    notifyListeners();
  }
}
