import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/api_services/booking/booking_api.dart';
import 'package:frontend/api_services/client/api_reponse.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';

class BookingViewModel extends ChangeNotifier {
  BookingViewModel();

  List<Booking> _bookings = [];
  List<Booking> get bookings => _bookings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

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
  Map<String, dynamic>? bookingResult;

  // Dữ liệu tạm thời để lưu trữ
  Map<String, dynamic>? _tempBookingData;
  Map<String, dynamic>? get tempBookingData => _tempBookingData;

  void setSelectedVehicle(Vehicle vehicle) {
    selectedVehicle = vehicle;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  // Hàm lưu dữ liệu tạm thời
  void saveData({
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
  }) {
    _tempBookingData = {
      "vehicleId": vehicleId,
      "renterId": renterId,
      "ownerId": ownerId,
      "pickupLocation": pickUpLocation,
      "dropoffLocation": dropOffLocation,
      "pickupDate": pickUpDate,
      "dropoffDate": dropOffDate,
      "pickupTime": pickUpTime,
      "dropoffTime": dropOffTime,
      "basePrice": basePrice,
    };
    notifyListeners();
  }

  Future<ApiResponse> createBooking({
    required AuthService authService,
  }) async {
    // Kiểm tra xem có dữ liệu tạm thời hay không
    if (_tempBookingData == null) {
      return ApiResponse(
        success: false,
        message: 'Không có dữ liệu đặt xe để gửi',
      );
    }

    // Gán dữ liệu từ tempBookingData
    vehicleId = _tempBookingData!['vehicleId'];
    renterId = _tempBookingData!['renterId'];
    ownerId = _tempBookingData!['ownerId'];
    pickUpLocation = _tempBookingData!['pickupLocation'];
    dropOffLocation = _tempBookingData!['dropoffLocation'];
    pickUpDate = _tempBookingData!['pickupDate'];
    dropOffDate = _tempBookingData!['dropoffDate'];
    pickUpTime = _tempBookingData!['pickupTime'];
    dropOffTime = _tempBookingData!['dropoffTime'];
    basePrice = _tempBookingData!['basePrice'];

    // Kiểm tra các trường bắt buộc
    if (vehicleId == null ||
        renterId == null ||
        ownerId == null ||
        pickUpLocation.isEmpty ||
        dropOffLocation.isEmpty ||
        pickUpDate.isEmpty ||
        dropOffDate.isEmpty ||
        pickUpTime.isEmpty ||
        dropOffTime.isEmpty ||
        basePrice == null ||
        basePrice! <= 0) {
      return ApiResponse(
        success: false,
        message: 'Vui lòng điền đầy đủ thông tin đặt xe',
      );
    }

    // Xử lý ngày giờ trong ViewModel
    try {
      final dateFormatter = DateFormat('dd-MM-yyyy');
      final pickupDate = dateFormatter.parseStrict(pickUpDate);
      final dropoffDate = dateFormatter.parseStrict(dropOffDate);

      final pickupTimeParts = pickUpTime.split(':');
      final dropoffTimeParts = dropOffTime.split(':');

      final pickupDateTime = DateTime(
        pickupDate.year,
        pickupDate.month,
        pickupDate.day,
        int.parse(pickupTimeParts[0]),
        int.parse(pickupTimeParts[1]),
      );

      final dropoffDateTime = DateTime(
        dropoffDate.year,
        dropoffDate.month,
        dropoffDate.day,
        int.parse(dropoffTimeParts[0]),
        int.parse(dropoffTimeParts[1]),
      );

      // Kiểm tra pickupDateTime không được trong quá khứ
      final now = DateTime.now();
      if (pickupDateTime.isBefore(now)) {
        return ApiResponse(
          success: false,
          message: 'Thời gian nhận xe không được nằm trong quá khứ',
        );
      }

      // Kiểm tra dropoffDateTime phải sau pickupDateTime
      if (dropoffDateTime.isBefore(pickupDateTime) || dropoffDateTime.isAtSameMomentAs(pickupDateTime)) {
        return ApiResponse(
          success: false,
          message: 'Thời gian trả xe phải sau thời gian nhận xe',
        );
      }

      totalRentalDays = dropoffDateTime.difference(pickupDateTime).inDays;

      final bookingData = {
        "vehicleId": vehicleId!,
        "renterId": renterId!,
        "ownerId": ownerId!,
        "pickupLocation": pickUpLocation,
        "dropoffLocation": dropOffLocation,
        "pickupDateTime": pickupDateTime.toUtc().toIso8601String(),
        "dropoffDateTime": dropoffDateTime.toUtc().toIso8601String(),
        "basePrice": basePrice!,
      };

      final response = await BookingApi.createBooking(
        viewModel: this,
        authService: authService,
        bookingData: bookingData,
      );

      if (response.success && response.data != null) {
        bookingResult = response.data is Map<String, dynamic> ? response.data : response.data['data'];
        basePrice = bookingResult?['basePrice']?.toDouble();
        taxAmount = bookingResult?['taxAmount']?.toDouble();
        totalPrice = bookingResult?['totalPrice']?.toDouble();
        // Xóa dữ liệu tạm thời sau khi tạo booking thành công
        _tempBookingData = null;
        reset();
        notifyListeners();
      }

      return response;
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Định dạng ngày hoặc giờ không hợp lệ: $e',
      );
    }
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

  getUserBookings() {}
}