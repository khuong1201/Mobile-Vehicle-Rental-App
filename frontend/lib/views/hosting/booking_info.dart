import 'package:flutter/material.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_text_body_m_sb.dart';
import 'package:frontend/views/widgets/custom_text_body_s_sb.dart';
import 'package:frontend/viewmodels/booking/booking_viewmodel.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/models/booking.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BookingInfomation extends StatefulWidget {
  final String bookingId;
  final String vehicleId; // từ notification

  const BookingInfomation({super.key, required this.bookingId, required this.vehicleId});

  @override
  State<BookingInfomation> createState() => _BookingInfomationState();
}

class _BookingInfomationState extends State<BookingInfomation> {
  Booking? _booking;
  Vehicle? _vehicle;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchBookingAndVehicle();
  }

  Future<void> _fetchBookingAndVehicle() async {
    final authService = context.read<AuthService>();
    final bookingVM = context.read<BookingViewModel>();
    final vehicleVM = context.read<VehicleViewModel>();

    try {
      // 1. Fetch Booking
      final booking = await bookingVM.getBookingById(widget.bookingId, authService);
      if (booking == null) {
        setState(() {
          _error = 'Không tìm thấy booking';
          _isLoading = false;
        });
        return;
      }

      // 2. Lấy vehicleId từ booking, fallback sang notification nếu null
      final vehicleId = (booking.vehicleId.isNotEmpty) ? booking.vehicleId : widget.vehicleId;

      // 3. Fetch Vehicle
      Vehicle? vehicle;
      if (vehicleId.isNotEmpty) {
        await vehicleVM.fetchVehicleById(context, vehicleId: vehicleId);
        vehicle = vehicleVM.currentVehicle;
      }

      setState(() {
        _booking = booking;
        _vehicle = vehicle;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Lỗi khi tải dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime dateTime) {
    final formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error!)),
      );
    }

    if (_booking == null || _vehicle == null) {
      return const Scaffold(
        body: Center(child: Text('Dữ liệu không hợp lệ')),
      );
    }

    return Scaffold(
      appBar: CustomAppbar(title: 'Itemized Charges'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            // Thông tin xe và giá
            Row(
              children: [
                Container(
                  width: 190,
                  height: 125,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        _vehicle!.images.isNotEmpty
                            ? _vehicle!.images[0]
                            : 'https://www.kia.com/content/dam/kwcms/gt/en/images/discover-kia/voice-search/parts-80-1.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: CustomTextBodyMsb(
                          title: _vehicle!.vehicleName,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextBodySsb(
                          title: "${_vehicle!.price.toStringAsFixed(0)} VND"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Thông tin booking
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomTextBodySsb(title: "Rental Period"),
                CustomTextBodySsb(
                    title:
                        '${_formatDate(_booking!.pickupDateTime)} - ${_formatDate(_booking!.dropoffDateTime)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomTextBodySsb(title: "Deliver To"),
                CustomTextBodySsb(title: _booking!.pickupLocation),
              ],
            ),
            const SizedBox(height: 32),
            // Thông tin người thuê / nhận xe
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.network(
                    '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset(
                      'assets/images/error/avatar.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome Bro',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFFF7F7F8),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const CustomTextBodySsb(title: "0987 654 321"),
                const SizedBox(height: 8),
                const CustomTextBodySsb(title: "123 Lý Tự Trọng, Quận 1"),
              ],
            ),
            const SizedBox(height: 16),
            // Thông tin chi phí
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomTextBodySsb(title: "Rental Fee :"),
                    CustomTextBodySsb(
                        title: _booking!.basePrice.toStringAsFixed(0)),
                  ],
                ),
                
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomTextBodySsb(title: "Total :"),
                    CustomTextBodySsb(
                        title:
                            _booking!.basePrice.toString(),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Xử lý Cancel
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.grey[700],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Xử lý Accept
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
