import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/views/widgets/custom_text_body_l.dart';

class AboutScreen extends StatelessWidget {
  final Vehicle vehicle;
  const AboutScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextBodyL(title: 'Rent Partner'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        vehicle.ownerAvatar,
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) => Image.asset(
                              'assets/images/error/avatar.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.ownerEmail,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.29,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vehicle.ownerName,
                          style: TextStyle(
                            color: const Color(0xFFAAACAF),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: const Color(0xFFE6E7E9),
                          width: 1,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/images/vehicle_detail/chat.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: const Color(0xFFE6E7E9),
                          width: 1,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/images/vehicle_detail/phone.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          CustomTextBodyL(title: 'Description'),
          const SizedBox(height: 16),
          Text(
            vehicle.description,
            style: TextStyle(
              color: const Color(0xFF808183),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.29,
            ),
          ),
        ],
      ),
    );
  }
}
