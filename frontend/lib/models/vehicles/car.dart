import 'package:frontend/models/bank.dart';
import 'package:frontend/models/location/location_for_vehicle.dart';
import 'package:frontend/models/vehicles/vehicle.dart';

class Car extends Vehicle {
  final String fuelType;
  final String transmission;
  final int numberOfSeats;

  Car({
    required String id,
    required String vehicleId,
    required String vehicleName,
    required String licensePlate,
    required String brandId,
    required String model,
    required int yearOfManufacture,
    required List<String> images,
    required List<String> imagePublicIds,
    required String description,
    LocationForVehicle? location,
    required String ownerId,
    required double price,
    BankAccount? bankAccount,
    required double averageRating,
    required int reviewCount,
    required bool available,
    required bool deleted,
    required String status,
    required this.fuelType,
    required this.transmission,
    required this.numberOfSeats,
  }) : super(
          id: id,
          vehicleId: vehicleId,
          vehicleName: vehicleName,
          licensePlate: licensePlate,
          brandId: brandId,
          model: model,
          yearOfManufacture: yearOfManufacture,
          images: images,
          imagePublicIds: imagePublicIds,
          description: description,
          location: location,
          ownerId: ownerId,
          price: price,
          bankAccount: bankAccount,
          averageRating: averageRating,
          reviewCount: reviewCount,
          available: available,
          deleted: deleted,
          status: status,
          type: 'Car',
        );

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
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
      fuelType: json['fuelType']?.toString() ?? '',
      transmission: json['transmission']?.toString() ?? '',
      numberOfSeats: (json['numberOfSeats'] ?? 0) as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'fuelType': fuelType,
      'transmission': transmission,
      'numberOfSeats': numberOfSeats,
    });
    return json;
  }
}