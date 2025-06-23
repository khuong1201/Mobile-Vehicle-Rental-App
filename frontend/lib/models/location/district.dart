class District {
  final String id;
  final String code;
  final String name;
  final String fullName;
  final String fullNameEn;
  final String divisionType;
  final String shortCodename;
  final String codename;
  final String provinceCode;
  final List<String> wardIds;

  District({
    required this.id,
    required this.code,
    required this.name,
    required this.fullName,
    required this.fullNameEn,
    required this.divisionType,
    required this.shortCodename,
    required this.codename,
    required this.provinceCode,
    required this.wardIds,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['_id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      fullNameEn: json['full_name_en'] as String? ?? '',
      divisionType: json['division_type'] as String? ?? '',
      shortCodename: json['short_codename'] as String? ?? '',
      codename: json['codename'] as String? ?? '',
      provinceCode: json['province_code'] as String? ?? '',
      wardIds: (json['wards'] as List<dynamic>?)?.cast<String>() ?? [],
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
      'short_codename': shortCodename,
      'codename': codename,
      'province_code': provinceCode,
      'wards': wardIds,
    };
  }
}