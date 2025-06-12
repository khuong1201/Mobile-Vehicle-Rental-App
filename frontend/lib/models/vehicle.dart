class Vehicle {
  final int id;
  final String image;
  final String logo;
  final String logoName;
  final String vehicleName;
  final String location;
  final String price;
  final double rating;
  final int rentals;
  final String type;

  Vehicle({
    required this.id,
    required this.image,
    required this.logo,
    required this.logoName,
    required this.vehicleName,
    required this.location,
    required this.price,
    required this.rating,
    required this.rentals,
    required this.type,
  });

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      image: map['image'],
      logo: map['logo'],
      logoName: map['logoName'],
      vehicleName: map['vehicleName'],
      location: map['location'],
      price: map['price'],
      rating: map['rating'].toDouble(),
      rentals: map['rentals'],
      type: map['type'],
    );
  }
}