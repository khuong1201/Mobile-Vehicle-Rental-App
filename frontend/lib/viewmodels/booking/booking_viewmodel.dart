import 'package:flutter/material.dart';
import 'package:frontend/api_services/booking/create_booking.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class BookingViewModel extends ChangeNotifier {
  String? vehicleId;
  String? renterId;
  String? ownerId;

  String pickUpLocation = '';
  String dropOffLocation = '';
  String pickUpDate = '';
  String dropOffDate = '';
  String pickUpTime = '';
  String dropOffTime = '';

  double? basePrice;
  double? taxAmount;
  double? totalPrice;
  int? totalRentalDays;
  String? _selectedPaymentMethod;
  String? get selectedPaymentMethod => _selectedPaymentMethod;
  Vehicle? selectedVehicle;

  void setSelectedVehicle(Vehicle vehicle) {
    selectedVehicle = vehicle;
    notifyListeners();
  }
  Map<String, dynamic>? bookingResult;

  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  Future<ApiResponse> createBooking({
    required String vehicleId,
    required String renterId,
    required String ownerId,
    required String pickUpLocation,
    required String dropOffLocation,
    required String pickUpDate,
    required String dropOffDate,
    required String pickUpTime,
    required String dropOffTime,
    required double basePrice,
    required AuthService authService,
  }) async {
    this.vehicleId = vehicleId;
    this.renterId = renterId;
    this.ownerId = ownerId;
    this.pickUpLocation = pickUpLocation;
    this.dropOffLocation = dropOffLocation;
    this.pickUpDate = pickUpDate;
    this.dropOffDate = dropOffDate;
    this.pickUpTime = pickUpTime;
    this.dropOffTime = dropOffTime;
    this.basePrice = basePrice;

    if (vehicleId.isEmpty || renterId.isEmpty || ownerId.isEmpty) {
      return ApiResponse(
        success: false,
        message: 'Thiếu thông tin đặt xe cần thiết',
      );
    }

    final bookingData = {
      "vehicleId": vehicleId,
      "renterId": renterId,
      "ownerId": ownerId,
      "pickupLocation": pickUpLocation,
      "dropoffLocation": dropOffLocation,
      "pickupDate": pickUpDate,
      "pickupTime": pickUpTime,
      "dropoffDate": dropOffDate,
      "dropoffTime": dropOffTime,
      "basePrice": basePrice,
    };

    final response = await BookingCreateApi.createBooking(
      viewModel: this,
      authService: authService,
      bookingData: bookingData,
    );

    if (response.success) {
      bookingResult = response.data?['booking'];
      basePrice = bookingResult?['basePrice']?.toDouble();
      taxAmount = bookingResult?['taxAmount']?.toDouble();
      totalPrice = bookingResult?['totalPrice']?.toDouble();
      totalRentalDays = bookingResult?['totalRentalDays']?.toInt();
      notifyListeners();
    }

    return response;
  }

  String get formattedTotalPrice {
    return totalPrice != null ? "${totalPrice!.toStringAsFixed(0)} VNĐ" : "0 VNĐ";
  }

  void reset() {
    vehicleId = null;
    renterId = null;
    ownerId = null;
    pickUpLocation = '';
    dropOffLocation = '';
    pickUpDate = '';
    dropOffDate = '';
    pickUpTime = '';
    dropOffTime = '';
    basePrice = null;
    taxAmount = null;
    totalPrice = null;
    totalRentalDays = null;
    _selectedPaymentMethod = null;
    bookingResult = null;
    selectedVehicle = null;
    notifyListeners();
  }
}