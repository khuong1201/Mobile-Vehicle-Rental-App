import 'package:frontend/models/location/location_for_vehicle.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

class Vehicle {
  final String id;
  final String vehicleId;
  final String vehicleName;
  final String licensePlate;
  final String brand;
  final String yearOfManufacture;
  final List<String> images;
  final String description;
  final LocationForVehicle? location;
  final String model;
  final String ownerId;
  final String ownerEmail;
  final String ownerName;
  final String ownerAvatar;
  final double price;
  final double rate;
  final double rentals;
  final bool available;
  final String status;
  final String type;

  Vehicle({
    required this.id,
    required this.vehicleId,
    required this.vehicleName,
    required this.licensePlate,
    required this.brand,
    required this.yearOfManufacture,
    required this.images,
    required this.description,
    required this.location,
    required this.model,
    required this.ownerId,
    required this.ownerEmail,
    required this.ownerName,
    required this.price,
    required this.rate,
    this.rentals = 0,
    required this.available,
    required this.status,
    required this.type, 
    required this.ownerAvatar,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    final ownerData = json['ownerId'];
    final ownerId =
        ownerData is String ? ownerData : (ownerData?['_id']?.toString() ?? '');
    final ownerEmail =
        ownerData is Map<String, dynamic>
            ? ownerData['email']?.toString() ?? ''
            : '';
    final ownerName =
        ownerData is Map<String, dynamic>
            ? ownerData['fullName']?.toString() ?? ''
            : '';
    final ownerAvatar =
        ownerData is Map<String, dynamic>
            ? ownerData['avatar']?.toString() ?? ''
            : '';
    return Vehicle(
      id: json['_id']?.toString() ?? '',
      vehicleId: json['vehicleId']?.toString() ?? '',
      vehicleName: json['vehicleName']?.toString() ?? '',
      licensePlate: json['licensePlate']?.toString() ?? '',
      brand:
          json['brand'] is Map<String, dynamic>
              ? Brand.fromJson(json['brand'] as Map<String, dynamic>).id
              : json['brand']?.toString() ?? '',
      yearOfManufacture: json['yearOfManufacture']?.toString() ?? '',
      images: List<String>.from(json['images'] ?? []),
      description: json['description']?.toString() ?? '',
      location:
          (json['location'] != null && json['location'] is Map<String, dynamic>)
              ? LocationForVehicle.fromJson(json['location'])
              : null,

      model: json['model']?.toString() ?? '',
      ownerId: ownerId,
      ownerEmail: ownerEmail,
      ownerName: ownerName,
      ownerAvatar: ownerAvatar,
      price: (json['price'] ?? 0).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
      rentals: (json['rentals'] ?? 0).toDouble(),
      available: json['available'] ?? true,
      status: json['status']?.toString() ?? 'pending',
      type: json['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'vehicleName': vehicleName,
      'licensePlate': licensePlate,
      'brand': brand,
      'model': model,
      'yearOfManufacture': yearOfManufacture,
      'images': images,
      'description': description,
      'location': location?.toJson(),
      'price': price,
      'rate': rate,
      'rentals': rentals,
      'available': available,
      'status': status,
      'type': type,
      'ownerId': ownerId,
      'ownerEmail': ownerEmail,
    };
  }

  String get formattedPrice => currencyFormatter.format(price);
}
