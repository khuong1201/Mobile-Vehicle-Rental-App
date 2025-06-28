class Booking {
  final String id;
  final String vehicleId;
  final String renterId;
  final String ownerId;
  final String pickupLocation;
  final String dropoffLocation;
  final String pickupDate;
  final String pickupTime;
  final String dropoffDate;
  final String dropoffTime;
  final double basePrice;
  final double totalRentalDays;
  final double taxRate;
  final double taxAmount;
  final double totalPrice;

  Booking({
    required this.id,
    required this.vehicleId,
    required this.renterId,
    required this.ownerId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupDate,
    required this.pickupTime,
    required this.dropoffDate,
    required this.dropoffTime,
    required this.basePrice,
    required this.taxRate,
    required this.totalRentalDays,
    required this.taxAmount,
    required this.totalPrice,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? '',
      vehicleId: json['vehicleId']?['_id'] ?? json['vehicleId'] ?? '',
      renterId: json['renterId']?['_id'] ?? json['renterId'] ?? '',
      ownerId: json['ownerId']?['_id'] ?? json['ownerId'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      dropoffLocation: json['dropoffLocation'] ?? '',
      pickupDate: json['pickupDate'] ?? '',
      pickupTime: json['pickupTime'] ?? '',
      dropoffDate: json['dropoffDate'] ?? '',
      dropoffTime: json['dropoffTime'] ?? '',
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      totalRentalDays: (json['totalRentalDays'] ?? 0).toDouble(),
      taxRate: (json['taxRate'] ?? 0).toDouble(),
      taxAmount: (json['taxAmount'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }
}