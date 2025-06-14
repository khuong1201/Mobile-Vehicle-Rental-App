import 'package:frontend/models/vehicles/vehicle.dart';

class Coach extends Vehicle {
  final String fuelType;
  final double fuelConsumption;
  final int numberOfSeats;

  Coach({
    required super.id,
    required super.vehicleId,
    required super.vehicleName,
    required super.licensePlate,
    required super.brand,
    required super.yearOfManufacture,
    required super.images,
    required super.description,
    required super.location,
    required super.ownerId,
    required super.ownerEmail,
    required super.price,
    required super.rate,
    required super.available,
    required super.status,
    required super.type,
    required this.fuelType,
    required this.fuelConsumption,
    required this.numberOfSeats,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    final vehicle = Vehicle.fromJson(json);
    return Coach(
      id: vehicle.id,
      vehicleId: vehicle.vehicleId,
      vehicleName: vehicle.vehicleName,
      licensePlate: vehicle.licensePlate,
      brand: vehicle.brand,
      yearOfManufacture: vehicle.yearOfManufacture,
      images: vehicle.images,
      description: vehicle.description,
      location: vehicle.location,
      ownerId: vehicle.ownerId,
      ownerEmail: vehicle.ownerEmail,
      price: vehicle.price,
      rate: vehicle.rate,
      available: vehicle.available,
      status: vehicle.status,
      type: vehicle.type,
      fuelType: json['fuelType'] ?? '',
      fuelConsumption: (json['fuelConsumption'] ?? 0).toDouble(),
      numberOfSeats: json['numberOfSeats'] ?? 0,
    );
  }
}
