
class Location {
  final String address;
  final double lat;
  final double lng;

  Location({
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'lat': lat,
      'lng': lng,
    };
  }
}

class Vehicle {
  final String id;
  final String vehicleId;
  final String vehicleName;
  final String licensePlate;
  final String brand;
  final String model;
  final int yearOfManufacture;
  final List<String> images;
  final String description;
  final Location? location;
  final String ownerId;
  final String ownerEmail;
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
    required this.model,
    required this.yearOfManufacture,
    required this.images,
    required this.description,
    required this.location,
    required this.ownerId,
    required this.ownerEmail,
    required this.price,
    required this.rate,
    this.rentals = 0,
    required this.available,
    required this.status,
    required this.type,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'] ?? '',
      vehicleId: json['vehicleId'] ?? '',
      vehicleName: json['vehicleName'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      brand: json['brand'] is Map ? json['brand']['_id'] : json['brand'],
      model: json['model'] ?? '',
      yearOfManufacture: json['yearOfManufacture'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      description: json['description'] ?? '',
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
      ownerId: json['ownerId'] ?? '',
      ownerEmail: json['ownerEmail'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
      available: json['available'] ?? true,
      status: json['status'] ?? 'pending',
      type: json['type'] ?? '',
    );
  }
}
