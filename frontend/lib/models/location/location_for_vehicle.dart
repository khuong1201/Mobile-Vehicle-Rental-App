class LocationForVehicle {
  final String type;
  final List<double> coordinates; // [lng, lat]
  final String address;

  LocationForVehicle({
    required this.type,
    required this.coordinates,
    required this.address,
  });

  factory LocationForVehicle.fromJson(Map<String, dynamic> json) {
    return LocationForVehicle(
      type: json['type']?.toString() ?? 'Point',
      coordinates: List<double>.from(
        (json['coordinates'] ?? [0.0, 0.0]).map((e) => e.toDouble()),
      ),
      address: json['address']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates.map((c) => c.toDouble()).toList(),
      'address': address,
    };
  }
}
