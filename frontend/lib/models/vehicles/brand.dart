import 'package:flutter/material.dart';

class Brand {
  final String brandId;
  final String brandName;
  final String? brandImage;

  Brand({
    required this.brandId,
    required this.brandName,
    this.brandImage,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    debugPrint('Parsing brand JSON: $json'); 
    return Brand(
      brandId: json['brandId']?.toString() ?? '',
      brandName: json['brandName']?.toString() ?? '',
      brandImage: json['brandImage']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brandId': brandId,
      'brandName': brandName,
      'brandImage': brandImage,
    };
  }
}