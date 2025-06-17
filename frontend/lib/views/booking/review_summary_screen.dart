import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/viewmodels/booking_viewmodel.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_text_body_L.dart';
import 'package:frontend/views/widgets/custom_text_body_S_sb.dart';
import 'package:frontend/views/widgets/custom_text_body_m_sb.dart';
import 'package:provider/provider.dart';

class ReviewSummaryScreen extends StatefulWidget {
  final Vehicle vehicle;

  const ReviewSummaryScreen({Key? key, required this.vehicle})
    : super(key: key);

  @override
  _ReviewSummaryScreenState createState() => _ReviewSummaryScreenState();
}

class _ReviewSummaryScreenState extends State<ReviewSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final bookingVM = Provider.of<BookingViewModel>(context);
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
                padding: EdgeInsets.symmetric(vertical: 20 ),
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
                                title: '${widget.vehicle.brand.brandName} ${widget.vehicle.vehicleName}',
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Text(
                                    widget.vehicle.rate.toString(),
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
                                child: SvgPicture.network(
                                  '${widget.vehicle.brand.brandImage}',
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.vehicle.brand.brandName,
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
                    )
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
                        CustomTextBodyMsb(title: bookingVM.pickUpDate)
                      ]
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CustomTextBodySsb(title: 'Pick - Up Time'),
                        Spacer(),
                        CustomTextBodyMsb(title: bookingVM.pickUpTime)
                      ]
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CustomTextBodySsb(title: 'Drop - Off Date'),
                        Spacer(),
                        CustomTextBodyMsb(title: bookingVM.dropOffDate)
                      ]
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CustomTextBodySsb(title: 'Drop - Off Time'),
                        Spacer(),
                        CustomTextBodyMsb(title: bookingVM.dropOffTime)
                      ]
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CustomTextBodySsb(title: 'Rent Type'),
                        Spacer(),
                        CustomTextBodyMsb(title: 'Self Driver')
                      ]
                    ),
                  ]
                )
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
                        CustomTextBodyMsb(title: '0 VNĐ')
                      ]
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CustomTextBodySsb(title: 'Subtotal'),
                        Spacer(),
                        CustomTextBodyMsb(title: bookingVM.formattedTotalPrice)
                      ]
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CustomTextBodySsb(title: 'Tax'),
                        Spacer(),
                        CustomTextBodyMsb(title: '0 VNĐ')
                      ]
                    ),
                  ]
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
