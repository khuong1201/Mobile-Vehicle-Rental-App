import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_text_body_L.dart';

class VehicleDetailScreen extends StatelessWidget {
  final Vehicle vehicle;
  VehicleDetailScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            CustomAppbar(title: 'Details'),
            const SizedBox(height: 28),
            Container(
              height: 213,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(vehicle.images.isNotEmpty
                      ? vehicle.images[0]
                      : 'https://via.placeholder.com/172'),
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
                      CustomTextBodyL(title: '${vehicle.brand} ${vehicle.vehicleName}'),
                      Spacer(),
                      Row(
                        children: [
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: SvgPicture.asset(
                              'assets/images/homePage/home/star.svg',
                            ),
                          ),
                          SizedBox(width: 3),
                          Text(
                            vehicle.rate.toString(),
                            style: TextStyle(
                              color: const Color(
                                0xFF2B2B2C,
                              ),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1.20,
                            ),
                          ),        
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: SvgPicture.asset(
                              'frontend/assets/images/logo/Mercedes.svg',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vehicle.brand,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.33,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset(''),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        )
      )
    );
  }
}