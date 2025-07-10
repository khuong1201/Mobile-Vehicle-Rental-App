class UserLicense {
  final String licenseId;
  final String classLicense;
  final String typeDriverLicense;
  final String licenseNumber;
  final String frontImage;
  final String backImage;
  final String status;
  UserLicense({
    required this.licenseId,
    required this.classLicense,
    required this.typeDriverLicense,
    required this.licenseNumber,
    required this.frontImage,
    required this.backImage,
    required this.status,
  });
  factory UserLicense.fromJson(Map<String, dynamic> json) {
    return UserLicense(
      licenseId: json['licenseId'] ?? '',
      classLicense: json['classLicense'] ?? '',
      typeDriverLicense: json['typeOfDriverLicense'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      frontImage: json['driverLicenseFront'] ?? '',
      backImage: json['driverLicenseBack'] ?? '',
      status: json['status'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'licenseId': licenseId,
      'classLicense': classLicense,
      'typeOfDriverLicense': typeDriverLicense,
      'licenseNumber': licenseNumber,
      'driverLicenseFront': frontImage,
      'driverLicenseBack': backImage,
    };
  }
}
