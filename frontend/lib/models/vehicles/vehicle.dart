
import 'dart:convert';

import 'package:frontend/models/bank.dart';
import 'package:frontend/models/location/location_for_vehicle.dart';
import 'package:frontend/models/vehicles/bike.dart';
import 'package:frontend/models/vehicles/car.dart';
import 'package:frontend/models/vehicles/coach.dart';
import 'package:frontend/models/vehicles/motorbike.dart';
import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

abstract class Vehicle {
  final String id;
  final String vehicleId;
  final String vehicleName;
  final String licensePlate;
  final String brandId; // Đổi từ brand sang brandId để khớp với JSON
  final String model;
  final int yearOfManufacture;
  final List<String> images;
  final List<String> imagePublicIds;
  final String description;
  final LocationForVehicle? location;
  final String ownerId;
  final double price;
  final BankAccount? bankAccount; // Cho phép null
  final double averageRating; // Đổi từ rate sang averageRating
  final int reviewCount; // Đổi từ rentals sang reviewCount
  final bool available;
  final bool deleted;
  final String status;
  final String type;

  Vehicle({
    required this.id,
    required this.vehicleId,
    required this.vehicleName,
    required this.licensePlate,
    required this.brandId,
    required this.model,
    required this.yearOfManufacture,
    required this.images,
    required this.imagePublicIds,
    required this.description,
    this.location,
    required this.ownerId,
    required this.price,
    this.bankAccount,
    required this.averageRating,
    required this.reviewCount,
    required this.available,
    required this.deleted,
    required this.status,
    required this.type,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    final type = (json['type'] ?? '').toString().toLowerCase();
    switch (type) {
      case 'car':
        return Car.fromJson(json);
      case 'motor':
      case 'motorbike':
        return Motor.fromJson(json);
      case 'coach':
        return Coach.fromJson(json);
      case 'bike':
        return Bike.fromJson(json);
      default:
        throw Exception('Unknown vehicle type: $type');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'vehicleId': vehicleId,
      'vehicleName': vehicleName,
      'licensePlate': licensePlate,
      'brandId': brandId,
      'model': model,
      'yearOfManufacture': yearOfManufacture,
      'images': images,
      'imagePublicIds': imagePublicIds,
      'description': description,
      'location': location?.toJson(),
      'ownerId': ownerId,
      'price': price,
      'bankAccount': bankAccount?.toJson(),
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'available': available,
      'deleted': deleted,
      'status': status,
      'type': type,
    };
  }

  Map<String, dynamic> toApiJson() {
  final json = toJson()
    ..remove('_id')
    ..remove('vehicleId')
    ..remove('createdAt')
    ..remove('__v');

  final result = <String, dynamic>{};

  json.forEach((key, value) {
    if (value == null) return;

    if (value is Map || value is List) {
      // Encode các object phức tạp
      result[key] = jsonEncode(value);
    } else {
      result[key] = value.toString();
    }
  });

  return result;
}

  String get formattedPrice => currencyFormatter.format(price);
}