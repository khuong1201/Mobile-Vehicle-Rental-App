class userLicense {
  final String name;
  final String classLicense;
  final String typeDriverLicense;
  final String licenseNumber;
  final String frontImage;
  final String backImage;
  userLicense({
    required this.name,
    required this.classLicense,
    required this.typeDriverLicense,
    required this.licenseNumber,
    required this.frontImage,
    required this.backImage,
  });
  factory userLicense.fromJson(Map<String, dynamic> json) {
    return userLicense(
      name: json['name'] ?? '',
      classLicense: json['classLicense'] ?? '',
      typeDriverLicense: json['typeDriverLicense'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      frontImage: json['frontImage'] ?? '',
      backImage: json['backImage'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'classLicense': classLicense,
      'typeDriverLicense': typeDriverLicense,
      'licenseNumber': licenseNumber,
      'frontImage': frontImage,
      'backImage': backImage,
    };
  }
}
