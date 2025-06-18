import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingViewModel extends ChangeNotifier {
  String pickUpLocation = '';
  String dropOffLocation = '';
  String pickUpDate = '';
  String dropOffDate = '';
  String pickUpTime = '';
  String dropOffTime = '';
  double? price;

  int rentalDays = 0;
  double totalPrice = 0;
  String formattedTotalPrice = '';
  String? _selectedPaymentMethod;

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
  String? get selectedPaymentMethod => _selectedPaymentMethod;

  void setBookingInfo({
    required String pickUpLocation,
    required String dropOffLocation,
    required String pickUpDate,
    required String dropOffDate,
    required String pickUpTime,
    required String dropOffTime,
    required double price,
  }) {
    this.pickUpLocation = pickUpLocation;
    this.dropOffLocation = dropOffLocation;
    this.pickUpDate = pickUpDate;
    this.dropOffDate = dropOffDate;
    this.pickUpTime = pickUpTime;
    this.dropOffTime = dropOffTime;
    this.price = price;

    _calculateRentalDetails();
    notifyListeners();
  }

  void _calculateRentalDetails() {
    try {
      final pickUp = _dateFormat.parseStrict(pickUpDate);
      final dropOff = _dateFormat.parseStrict(dropOffDate);
      final days = dropOff.difference(pickUp).inDays;
      rentalDays =  days > 0 ? days : 1; 
    } catch (_) {
      rentalDays = 0;
    }

    totalPrice = (price ?? 0) * rentalDays;
    formattedTotalPrice = _currencyFormat.format(totalPrice);

  }

  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }
}