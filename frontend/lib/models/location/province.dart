class Province {
  final String id;
  final String code;
  final String name;
  final String fullName;
  final String fullNameEn;
  final String divisionType;
  final int phoneCode;
  final List<String> districtIds;

  Province({
    required this.id,
    required this.code,
    required this.name,
    required this.fullName,
    required this.fullNameEn,
    required this.divisionType,
    required this.phoneCode,
    required this.districtIds,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['_id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      fullNameEn: json['full_name_en'] as String,
      divisionType: json['division_type'] as String,
      phoneCode: json['phone_code'] as int,
      districtIds: List<String>.from(json['districts']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'code': code,
      'name': name,
      'full_name': fullName,
      'full_name_en': fullNameEn,
      'division_type': divisionType,
      'phone_code': phoneCode,
      'districts': districtIds,
    };
  }
}
