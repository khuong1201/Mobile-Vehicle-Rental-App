import 'package:flutter/material.dart';
import 'package:frontend/api_services/booking/create_booking.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
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

  String? _selectedPaymentMethod;

  
  String? get selectedPaymentMethod => _selectedPaymentMethod;


  /// Đổi phương thức thanh toán
  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  /// Tạo booking - Call API
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
        message: 'Missing required booking information',
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
      reset();
    }

    return response;
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
    basePrice = 0;
    _selectedPaymentMethod = null;
    notifyListeners();
  }
}
