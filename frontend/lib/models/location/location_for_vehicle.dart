class LocationForVehicle {
  final String? address;
  final double? lat;
  final double? lng;

  LocationForVehicle({
    this.address,
    this.lat,
    this.lng,
  });

  factory LocationForVehicle.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return LocationForVehicle(
        address: null,
        lat: null,
        lng: null,
      );
    }
    return LocationForVehicle(
      address: json['address'] as String?,
      lat: json['lat'] as double?,
      lng: json['lng'] as double?,
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      'address': address,
      'lat': lat,
      'lng': lng,
    };
  }

  @override
  String toString() => address ?? '';
}