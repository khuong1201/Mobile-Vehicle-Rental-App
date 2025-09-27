import 'package:frontend/models/vehicles/vehicle.dart';

class Booking {
  final String id;
  final String vehicleId;
  final String renterId;
  final String ownerId;
  final String pickupLocation;
  final String dropoffLocation;

  final DateTime pickupDateTime;
  final DateTime dropoffDateTime;

  final String pickupDate;
  final String pickupTime;
  final String dropoffDate;
  final String dropoffTime;

  final String status;
  final double basePrice;
  final double taxRate;
  final double taxAmount;
  final double totalPrice;

  final bool deleted;
  final bool isTaxDeducted;
  final String bookingId;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int totalRentalDays;

  Vehicle? vehicle;

  Booking({
    required this.id,
    required this.vehicleId,
    required this.renterId,
    required this.ownerId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupDateTime,
    required this.dropoffDateTime,
    required this.pickupDate,
    required this.pickupTime,
    required this.dropoffDate,
    required this.dropoffTime,
    required this.status,
    required this.basePrice,
    required this.taxRate,
    required this.taxAmount,
    required this.totalPrice,
    required this.deleted,
    required this.isTaxDeducted,
    required this.bookingId,
    required this.createdAt,
    required this.updatedAt,
    required this.totalRentalDays,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    final pickupDT = DateTime.parse(json['pickupDateTime']);
    final dropoffDT = DateTime.parse(json['dropoffDateTime']);

    return Booking(
      id: json['_id'] ?? '',
      vehicleId: json['vehicleId'] ?? '',
      renterId: json['renterId'] ?? '',
      ownerId: json['ownerId'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      dropoffLocation: json['dropoffLocation'] ?? '',
      pickupDateTime: pickupDT,
      dropoffDateTime: dropoffDT,
      pickupDate: pickupDT.toLocal().toString().split(' ')[0], // yyyy-MM-dd
      pickupTime: "${pickupDT.hour.toString().padLeft(2, '0')}:${pickupDT.minute.toString().padLeft(2, '0')}",
      dropoffDate: dropoffDT.toLocal().toString().split(' ')[0],
      dropoffTime: "${dropoffDT.hour.toString().padLeft(2, '0')}:${dropoffDT.minute.toString().padLeft(2, '0')}",
      status: json['status'] ?? '',
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      taxRate: (json['taxRate'] ?? 0).toDouble(),
      taxAmount: (json['taxAmount'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      deleted: json['deleted'] ?? false,
      isTaxDeducted: json['isTaxDeducted'] ?? false,
      bookingId: json['bookingId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      totalRentalDays: dropoffDT.difference(pickupDT).inDays,
    );
  }
}
