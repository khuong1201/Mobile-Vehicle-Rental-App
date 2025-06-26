class LocationForVehicle {
  final String address;
  final double lat;
  final double lng;

  LocationForVehicle({
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory LocationForVehicle.fromJson(Map<String, dynamic> json) {
    return LocationForVehicle(
      address: json['address']?.toString() ?? '',
      lat: _parseToDouble(json['lat']),
      lng: _parseToDouble(json['lng']),
    );
  }

  static double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'lat': lat,
      'lng': lng,
    };
  }
}
