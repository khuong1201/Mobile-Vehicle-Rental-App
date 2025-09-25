import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/location/location_for_vehicle.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
import 'package:frontend/viewmodels/booking/booking_viewmodel.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/views/booking/review_summary_screen.dart';
import 'package:frontend/views/hosting/rentalInfomation/location/location_screen.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_date_formfield.dart';
import 'package:frontend/views/widgets/custom_text_body_l.dart';
import 'package:frontend/views/widgets/custom_text_body_m_sb.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  final Vehicle vehicle;
  const BookingScreen({super.key, required this.vehicle});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _pickUpLocationController = TextEditingController();
  final TextEditingController _dropOffLocationController = TextEditingController();
  final TextEditingController _pickUpDateController = TextEditingController();
  final TextEditingController _dropOffDateController = TextEditingController();
  final TextEditingController _pickUpTimeController = TextEditingController();
  final TextEditingController _dropOffTimeController = TextEditingController();

  final dateFormat = DateFormat("dd-MM-yyyy");

  DateTime? parseDate(String input) {
    try {
      return DateFormat("dd-MM-yyyy").parseStrict(input);
    } catch (_) {
      return null;
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bookingVM = Provider.of<BookingViewModel>(context);
    final brands = Provider.of<VehicleViewModel>(context).brands;
    final Brand brand = brands.firstWhere(
      (b) => b.brandId == widget.vehicle.brandId,
      orElse: () => Brand(
        id: '',
        brandId: '',
        brandName: 'unknown',
        brandImage: null,
      ),
    );
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color(0xffFCFCFC),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomAppbar(title: 'Booking'),
              const SizedBox(height: 28),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      height: 213,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            widget.vehicle.images.isNotEmpty
                                ? widget.vehicle.images[0]
                                : 'https://www.kia.com/content/dam/kwcms/gt/en/images/discover-kia/voice-search/parts-80-1.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CustomTextBodyL(
                                title: '${brand.brandName} ${widget.vehicle.vehicleName}',
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Text(
                                    widget.vehicle.averageRating.toString(),
                                    style: TextStyle(
                                      color: const Color(0xFF2B2B2C),
                                      fontSize: 10,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 1.20,
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: SvgPicture.asset(
                                      'assets/images/homePage/home/star.svg',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: Image.network(
                                  '${brand.brandImage}',
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                brand.brandName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextBodyMsb(title: 'Pick - Up Location'),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  controller: _pickUpLocationController,
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      final result = await Navigator.push<LocationForVehicle?>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const LocationScreen(),
                                        ),
                                      );
                                      if (result != null) {
                                        setState(() {
                                          _pickUpLocationController.text = result.address;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter pick - up location';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 28),
                                CustomTextBodyMsb(title: 'Drop - Off Location'),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  controller: _dropOffLocationController,
                                  suffixIcon: IconButton(
                                    onPressed: () async {
                                      final result = await Navigator.push<LocationForVehicle?>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const LocationScreen(),
                                        ),
                                      );
                                      if (result != null) {
                                        setState(() {
                                          _dropOffLocationController.text = result.address;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter drop - off location';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 28),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomTextBodyMsb(
                                            title: 'Pick - Up Date',
                                          ),
                                          const SizedBox(height: 10),
                                          CustomDateFormField(
                                            controller: _pickUpDateController,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Vui lòng chọn ngày';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomTextBodyMsb(
                                            title: 'Pick - Up Time',
                                          ),
                                          const SizedBox(height: 10),
                                          CustomTextField(
                                            controller: _pickUpTimeController,
                                            hintText: 'Select Time',
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Vui lòng chọn thời gian';
                                              }
                                              if (!RegExp(r'^\d{2}:\d{2}$').hasMatch(value)) {
                                                return 'Định dạng giờ phải là HH:mm';
                                              }
                                              try {
                                                final parts = value.split(':');
                                                final hour = int.parse(parts[0]);
                                                final minute = int.parse(parts[1]);
                                                if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
                                                  return 'Giờ hoặc phút không hợp lệ';
                                                }
                                              } catch (e) {
                                                return 'Định dạng giờ không hợp lệ';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 28),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomTextBodyMsb(
                                            title: 'Drop - Off Date',
                                          ),
                                          const SizedBox(height: 10),
                                          CustomDateFormField(
                                            controller: _dropOffDateController,
                                            firstDate: _pickUpDateController.text.isNotEmpty
                                                ? (parseDate(_pickUpDateController.text) ?? DateTime.now())
                                                : DateTime.now(),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Vui lòng chọn ngày';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomTextBodyMsb(
                                            title: 'Drop - Off Time',
                                          ),
                                          const SizedBox(height: 10),
                                          CustomTextField(
                                            controller: _dropOffTimeController,
                                            hintText: 'Select Time',
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Vui lòng chọn thời gian';
                                              }
                                              if (!RegExp(r'^\d{2}:\d{2}$').hasMatch(value)) {
                                                return 'Định dạng giờ phải là HH:mm';
                                              }
                                              try {
                                                final parts = value.split(':');
                                                final hour = int.parse(parts[0]);
                                                final minute = int.parse(parts[1]);
                                                if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
                                                  return 'Giờ hoặc phút không hợp lệ';
                                                }
                                              } catch (e) {
                                                return 'Định dạng giờ không hợp lệ';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: const Color(0xFFD5D7DB), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: TextStyle(
                    color: const Color(0xFF808183),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      widget.vehicle.formattedPrice.toString(),
                      style: TextStyle(
                        color: const Color(0xFF000000),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '/ day',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF808183),
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            CustomButton(
              onPressed: () async {
                final authService = AuthService(context);
                final userId = await authService.getUserIdFromStorage();
                if (_formKey.currentState!.validate()) {
                  bookingVM.setSelectedVehicle(widget.vehicle);
                  final response = await bookingVM.createBooking(
                    authService: authService,
                    vehicleId: widget.vehicle.vehicleId,
                    renterId: userId!,
                    ownerId: widget.vehicle.ownerId,
                    pickUpLocation: _pickUpLocationController.text,
                    dropOffLocation: _dropOffLocationController.text,
                    pickUpDate: _pickUpDateController.text,
                    dropOffDate: _dropOffDateController.text,
                    pickUpTime: _pickUpTimeController.text,
                    dropOffTime: _dropOffTimeController.text,
                    basePrice: widget.vehicle.price,
                  );
                  debugPrint('Booking response: ${response.success}, ${response.message}');
                  if (response.success) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewSummaryScreen(vehicle: widget.vehicle),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response.message ?? 'Lỗi khi tạo booking'),
                      ),
                    );
                  }
                }
              },
              title: 'Rent Now',
              width: 150,
            ),
          ],
        ),
      ),
    );
  }
}