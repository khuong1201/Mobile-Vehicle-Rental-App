import 'package:frontend/models/location/district.dart';
import 'package:frontend/models/location/province.dart';
import 'package:frontend/models/location/ward.dart';

class Locations {
  final Province province;
  final District district;
  final Ward ward;

  Locations({
    required this.province,
    required this.district,
    required this.ward,
  });

  factory Locations.fromJson(Map<String, dynamic> json) => Locations(
    province: Province.fromJson(json['province']),
    district: District.fromJson(json['district']),
    ward: Ward.fromJson(json['ward']),
  );

  Map<String, dynamic> toJson() => {
    'province': province.toJson(),
    'district': district.toJson(),
    'ward': ward.toJson(),
  };

  @override
  String toString() => '${ward.name}, ${district.name}, ${province.name}';
}

