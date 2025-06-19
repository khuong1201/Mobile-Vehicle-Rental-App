import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/views/widgets/custom_text_body_L.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextBodyL(title: 'Review'),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              margin:EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFE5E5E5),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                '',
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
                            Text(
                              'Laura Master',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 1.29,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'assets/images/vehicle_detail/time.svg',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '30 March 2025',
                              style: TextStyle(
                                color: const Color(0xFF808183),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.29,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The Ford Everest Platinum 2025 is the highest-end version of the 7-seat Ford Everest SUV lineup, officially distributed in Vietnam. Positioned as the most versatile 7-seat SUV in its segment, the vehicle inherits the strengths of its predecessors, including a solid chassis, thick bodywork, excellent sound insulation, and an authentic driving feel.',
                    style: TextStyle(
                      color: const Color(0xFF808183),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.29,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
