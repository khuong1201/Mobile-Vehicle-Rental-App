import 'package:frontend/models/vehicles/vehicle.dart';

class Motor extends Vehicle {
  final String fuelType;

  Motor({
    required super.id,
    required super.vehicleId,
    required super.vehicleName,
    required super.licensePlate,
    required super.brand,
    required super.yearOfManufacture,
    required super.images,
    required super.description,
    required super.location,
    required super.model,
    required super.ownerId,
    required super.ownerEmail,
    required super.ownerName,
    required super.ownerAvatar,
    required super.price,
    required super.bankAccount,
    required super.rate,
    required super.available,
    required super.status,
    required super.type,
    required this.fuelType,
  });

  factory Motor.fromJson(Map<String, dynamic> json) {
    final vehicle = Vehicle.fromJson(json);
    return Motor(
      id: vehicle.id,
      vehicleId: vehicle.vehicleId,
      vehicleName: vehicle.vehicleName,
      licensePlate: vehicle.licensePlate,
      brand: vehicle.brand,
      yearOfManufacture: vehicle.yearOfManufacture,
      images: vehicle.images,
      description: vehicle.description,
      location: vehicle.location,
      model: vehicle.model,
      ownerId: vehicle.ownerId,
      ownerEmail: vehicle.ownerEmail,
      ownerName: vehicle.ownerName,
      ownerAvatar: vehicle.ownerAvatar,
      price: vehicle.price,
      bankAccount: vehicle.bankAccount,
      rate: vehicle.rate,
      available: vehicle.available,
      status: vehicle.status,
      type: vehicle.type,
      fuelType: json['fuelType'] ?? '',
    );
  }
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'fuelType': fuelType,
    });
    return json;
  }
}
