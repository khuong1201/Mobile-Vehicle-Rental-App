import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/api_services/payment/momo_api.dart';
import 'package:frontend/api_services/payment/vietin_api.dart';
import 'package:frontend/api_services/payment/viettin_api_IPN.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/models/momo_payment.dart';
import 'package:frontend/models/vehicles/brand.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/models/viettin_payment.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
import 'package:frontend/viewmodels/booking/booking_viewmodel.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/views/booking/confirmation_screen.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_text_body_l.dart';
import 'package:frontend/views/widgets/custom_text_body_s_sb.dart';
import 'package:frontend/views/widgets/custom_text_body_m_sb.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewSummaryScreen extends StatefulWidget {
  final Vehicle vehicle;
  const ReviewSummaryScreen({super.key,required this.vehicle});
  
  @override
  _ReviewSummaryScreenState createState() => _ReviewSummaryScreenState();
}

class _ReviewSummaryScreenState extends State<ReviewSummaryScreen> {
  int selectedIndex = 0;
  final List<Map<String, String>> paymentMethods = [
    {'name': 'VTB', 'image': 'assets/images/booking/viettin.png'},
    {'name': 'MoMo wallet', 'image': 'assets/images/booking/momo.png'},
    {'name': 'ZaloPay', 'image': 'assets/images/booking/zalo.png'},
  ];
  Booking? booking;
  bool isLoading = true;
  String? errorMessage;
  
  @override
  void initState() {
    super.initState();
    final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
    setState(() {
      booking = bookingVM.currentBooking;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingVM = Provider.of<BookingViewModel>(context, listen: false);
    final brands = Provider.of<VehicleViewModel>(context).brands;
    final Brand brand = brands.firstWhere(
      (b) => b.brandId == widget.vehicle.brandId,
      orElse:
          () => Brand(
            id: '',
            brandId: '',
            brandName: 'unknown',
            brandImage: null,
          ),
    );

    // Thêm kiểm tra trạng thái dữ liệu
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(errorMessage!)),
      );
    }
    if (booking == null) {
      return Scaffold(
        body: Center(child: Text('Không tìm thấy thông tin booking')),
      );
    }

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppbar(title: 'Review Summary'),
              const SizedBox(height: 28),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffD5D7DB)),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 80,
                      width: 94,
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
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomTextBodyL(
                                title:
                                    '${brand.brandName} ${widget.vehicle.vehicleName}',
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
                          const SizedBox(height: 4),
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
                          const SizedBox(height: 4),
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffD5D7DB)),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomTextBodySsb(title: 'Pick - Up Date'),
                        Spacer(),
                        CustomTextBodyMsb(title: booking!.pickupDate),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CustomTextBodySsb(title: 'Pick - Up Time'),
                        Spacer(),
                        CustomTextBodyMsb(title: booking!.pickupTime),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CustomTextBodySsb(title: 'Drop - Off Date'),
                        Spacer(),
                        CustomTextBodyMsb(title: booking!.dropoffDate),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CustomTextBodySsb(title: 'Drop - Off Time'),
                        Spacer(),
                        CustomTextBodyMsb(title: booking!.dropoffTime),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CustomTextBodySsb(title: 'Total Rental Days'),
                        Spacer(),
                        CustomTextBodyMsb(title: booking!.totalRentalDays.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffD5D7DB)),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomTextBodySsb(title: 'Additional Drive'),
                        Spacer(),
                        CustomTextBodyMsb(title: '0 VNĐ'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CustomTextBodySsb(title: 'Subtotal'),
                        Spacer(),
                        CustomTextBodyMsb(title: bookingVM.formattedPrice(booking!.totalPrice)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CustomTextBodySsb(title: 'Tax'),
                        Spacer(),
                        CustomTextBodyMsb( title: bookingVM.formattedPrice(booking!.taxRate), 
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomTextBodyMsb(title: 'Payment'),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See all',
                            style: TextStyle(
                              color: const Color(0xFF1976D2),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 1.21,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: paymentMethods.length,
                        itemBuilder: (context, index) {
                          final isSelected = index == selectedIndex;
                          final method = paymentMethods[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              bookingVM.setPaymentMethod(
                                paymentMethods[index]['name']!,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(right: 16),
                              width: 162,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Color(0xFF1976D2)
                                          : Color(0XffAAACAF),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(method['image']!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    children: [
                                      Text(
                                        method['name']!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          height: 1.21,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Color(0xffD5D7DB))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/booking/Vector.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    CustomTextBodyMsb(title: 'Promotions'),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      'Choose or enter code',
                      style: TextStyle(
                        color: const Color(0xFF808183),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.29,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xff000000),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextBodyL(title: 'Total Rental Price'),
                Text(
                  bookingVM.formattedPrice(booking!.totalPrice),
                  style: TextStyle(
                    color: const Color(0xFF1976D2),
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              width: double.infinity,
              onPressed: () async {
                final bookingVM = Provider.of<BookingViewModel>(
                  context,
                  listen: false,
                );
                final authService = AuthService(context);

                if (bookingVM.selectedPaymentMethod == 'MoMo wallet') {
                  final response = await PaymentMomoApi.createMomoPayment(
                    viewModel: bookingVM,
                    apiAuthService: authService,
                    paymentData: {
                      "bookingId": booking!.bookingId,
                      "amount": bookingVM.totalPrice ?? 0,
                      "orderInfo": "Thanh toán thuê xe",
                    },
                  );

                  if (response.success && response.data != null) {
                    
                    final momo = response.data as MomoPayment;
                    final Uri momoUri = Uri.parse(momo.payUrl);

                    if (await canLaunchUrl(momoUri)) {
                      await launchUrl(
                        momoUri,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Không thể mở liên kết thanh toán MoMo',
                          ),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          response.message ?? 'Lỗi khi tạo thanh toán',
                        ),
                      ),
                    );
                  }
                } else if (bookingVM.selectedPaymentMethod == 'VTB') {
                  final response = await PaymentViettinApi.createViettinPayment(
                    viewModel: bookingVM,
                    apiAuthService: authService,
                    paymentData: {
                      "bookingId": booking!.bookingId,
                      "amount": bookingVM.totalPrice ?? 0,
                      "orderInfo": "Thanh toán thuê xe",
                    },
                  );
                  
                  if (response.success && response.data != null) {
                    debugPrint(
                      'Viettin payment created successfully; response: ${response.data}',
                    );
                    final viettin = response.data as ViettinPayment;
                    final ipnResponse =
                        await PaymentViettinApiIPN.viettinpayment(
                          viewModel: bookingVM,
                          apiAuthService: authService,
                          paymentData: {
                            "paymentId": viettin.paymentId,
                            "resultCode": 0,
                            "message": "Thanh toán giả định thành công",
                          },
                        );

                    if (ipnResponse.success) {
                      debugPrint(
                        'IPN processed successfully; response: ${ipnResponse.data}',
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  Confirmationscreen(vehicle: widget.vehicle),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ipnResponse.message ?? 'Lỗi khi xử lý IPN',
                          ),
                        ),
                      );
                    }
                  }
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              Confirmationscreen(vehicle: widget.vehicle),
                    ),
                  );
                }
              },
              title: 'Pay Now',
            ),
          ],
        ),
      ),
    );
  }
}