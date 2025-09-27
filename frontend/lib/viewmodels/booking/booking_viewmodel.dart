import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
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

  Booking? _currentBooking;
  Booking? get currentBooking => _currentBooking;

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
  String? result;

  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
  String formattedPrice(num? value) {
    return currencyFormatter.format(value ?? 0);
  }

  void setSelectedVehicle(Vehicle vehicle) {
    selectedVehicle = vehicle;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  Future<ApiResponse> createBooking({
    required AuthService authService,
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
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

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

    // Kiểm tra các trường bắt buộc
    if (vehicleId.isEmpty ||
        renterId.isEmpty ||
        ownerId.isEmpty ||
        pickUpLocation.isEmpty ||
        dropOffLocation.isEmpty ||
        pickUpDate.isEmpty ||
        dropOffDate.isEmpty ||
        pickUpTime.isEmpty ||
        dropOffTime.isEmpty ||
        basePrice <= 0) {
      _isLoading = false;
      _errorMessage = 'Vui lòng điền đầy đủ thông tin đặt xe';
      notifyListeners();
      return ApiResponse(
        success: false,
        message: 'Vui lòng điền đầy đủ thông tin đặt xe',
      );
    }

    // Xử lý ngày giờ
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
        _isLoading = false;
        _errorMessage = 'Thời gian nhận xe không được nằm trong quá khứ';
        notifyListeners();
        return ApiResponse(
          success: false,
          message: 'Thời gian nhận xe không được nằm trong quá khứ',
        );
      }

      // Kiểm tra dropoffDateTime phải sau pickupDateTime
      if (dropoffDateTime.isBefore(pickupDateTime) ||
          dropoffDateTime.isAtSameMomentAs(pickupDateTime)) {
        _isLoading = false;
        _errorMessage = 'Thời gian trả xe phải sau thời gian nhận xe';
        notifyListeners();
        return ApiResponse(
          success: false,
          message: 'Thời gian trả xe phải sau thời gian nhận xe',
        );
      }

      final bookingData = {
        "vehicleId": vehicleId,
        "renterId": renterId,
        "ownerId": ownerId,
        "pickupLocation": pickUpLocation,
        "dropoffLocation": dropOffLocation,
        "pickupDateTime": pickupDateTime.toIso8601String(),
        "dropoffDateTime": dropoffDateTime.toIso8601String(),
        "basePrice": basePrice,
      };

      final response = await BookingApi.createBooking(
        viewModel: this,
        authService: authService,
        bookingData: bookingData,
      );

      if (response.success && response.data != null) {
      final booking = response.data as Booking;

      _currentBooking = booking;

      debugPrint("✅ BookingId: ${booking.bookingId}");

      _isLoading = false;
      notifyListeners();
      return ApiResponse(success: true, data: booking, message: response.message);
    }
      
      _isLoading = false;
      notifyListeners();
      return response;
      
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Định dạng ngày hoặc giờ không hợp lệ: $e';
      notifyListeners();
      return ApiResponse(
        success: false,
        message: 'Định dạng ngày hoặc giờ không hợp lệ: $e',
      );
    }
  }

  Future<void> fetchUserBookings(
    BuildContext context,
    AuthService authService,{
    required VehicleViewModel vehicleVM,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await BookingApi.getUserBookings(
      viewModel: this,
      authService: authService,
    );

    if (response.success && response.data != null) {
      _bookings = response.data!;

      for (var booking in _bookings) {
        await vehicleVM.fetchVehicleById(context, vehicleId: booking.vehicleId);
        booking.vehicle = vehicleVM.currentVehicle;
      }

    } else {
      _errorMessage = response.message ?? 'Không thể tải danh sách booking';
      _bookings = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Booking?> getBookingById(String bookingId, AuthService authService) async {
    if (bookingId.isEmpty) {
      _errorMessage = 'bookingId không được để trống';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await BookingApi.getBookingById(
        viewModel: this,
        authService: authService,
        bookingId: bookingId,
      );

      if (response.success && response.data != null) {
        final res = response.data as Map<String, dynamic>;
        final data = res['data'] as Map<String, dynamic>;

        final booking = Booking.fromJson(data);
        // Cập nhật danh sách bookings nếu chưa có
        if (!_bookings.any((b) => b.bookingId == booking.bookingId)) {
          _bookings.add(booking);
        }

        _isLoading = false;
        notifyListeners();
        return booking;
      } else {
        _errorMessage = response.message ?? 'Lỗi khi lấy thông tin booking';
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _errorMessage = 'Lỗi khi lấy thông tin booking: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
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
    selectedVehicle = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}