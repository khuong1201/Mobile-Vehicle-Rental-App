import 'package:frontend/models/bank.dart';
import 'package:frontend/models/location/location_for_vehicle.dart';
import 'package:frontend/models/vehicles/vehicle.dart';

class Bike extends Vehicle {
  final String typeOfBike;

  Bike({
    required super.id,
    required super.vehicleId,
    required super.vehicleName,
    required super.licensePlate,
    required super.brandId, // Đổi từ brand sang brandId
    required super.model,
    required super.yearOfManufacture,
    required super.images,
    required super.imagePublicIds, // Thêm imagePublicIds
    required super.description,
    super.location, // Nullable
    required super.ownerId,
    required super.price,
    super.bankAccount, // Nullable
    required super.averageRating, // Đổi từ rate sang averageRating
    required super.reviewCount, // Đổi từ rentals sang reviewCount
    required super.available,
    required super.deleted, // Thêm deleted
    required super.status,
    required this.typeOfBike,
  }) : super(type: 'Bike'); // Gọi constructor của Vehicle với type cố định

  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(
      id: json['_id']?.toString() ?? '',
      vehicleId: json['vehicleId']?.toString() ?? '',
      vehicleName: json['vehicleName']?.toString() ?? '',
      licensePlate: json['licensePlate']?.toString() ?? '',
      brandId: json['brandId']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      yearOfManufacture: (json['yearOfManufacture'] ?? 0) as int,
      images: List<String>.from(json['images'] ?? []),
      imagePublicIds: List<String>.from(json['imagePublicIds'] ?? []),
      description: json['description']?.toString() ?? '',
      location: json['location'] != null
          ? LocationForVehicle.fromJson(json['location'])
          : null,
      ownerId: json['ownerId']?.toString() ?? '',
      price: (json['price'] ?? 0).toDouble(),
      bankAccount: json['bankAccount'] != null
          ? BankAccount.fromJson(json['bankAccount'])
          : null,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      reviewCount: (json['reviewCount'] ?? 0) as int,
      available: json['available'] ?? true,
      deleted: json['deleted'] ?? false,
      status: json['status']?.toString() ?? 'pending',
      typeOfBike: json['typeOfBike']?.toString() ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['typeOfBike'] = typeOfBike;
    return json;
  }

  @override
  Map<String, dynamic> toApiJson() {
    final json = super.toApiJson();
    json['typeOfBike'] = typeOfBike;
    return json;
  }
}