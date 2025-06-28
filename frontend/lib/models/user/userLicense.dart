class UserLicense {
  final String classLicense;
  final String typeDriverLicense;
  final String licenseNumber;
  final String frontImage;
  final String backImage;
  UserLicense({
    required this.classLicense,
    required this.typeDriverLicense,
    required this.licenseNumber,
    required this.frontImage,
    required this.backImage,
  });
  factory UserLicense.fromJson(Map<String, dynamic> json) {
    return UserLicense(
      classLicense: json['classLicense'] ?? '',
      typeDriverLicense: json['typeDriverLicense'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      frontImage: json['frontImage'] ?? '',
      backImage: json['backImage'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'classLicense': classLicense,
      'typeDriverLicense': typeDriverLicense,
      'licenseNumber': licenseNumber,
      'frontImage': frontImage,
      'backImage': backImage,
    };
  }
}
