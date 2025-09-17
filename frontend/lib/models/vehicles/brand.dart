import 'package:flutter/material.dart';

class Brand {
  final String id;
  final String brandId;
  final String brandName;
  final String? brandImage;

  Brand({
    required this.id,
    required this.brandId,
    required this.brandName,
    this.brandImage,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    debugPrint('Parsing brand JSON: $json');
    
    return Brand(
      id: json['_id']?.toString() ?? '',
      brandId: json['brandId']?.toString() ?? '',
      brandName: json['brandName']?.toString() ?? '',
      brandImage: json['brandLogo'] != null ? json['brandLogo']['url']?.toString() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'brandId': brandId,
      'brandName': brandName,
      'brandLogo': brandImage,
    };
  }
}
