import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/viewmodels/vehicle/review_viewmodel.dart';
import 'package:frontend/views/widgets/custom_text_body_L.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatelessWidget {
  final Vehicle vehicle;
  const ReviewScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final reviewViewModel = Provider.of<ReviewViewModel>(context,listen: false);

    Future.microtask(() {
      reviewViewModel.fetchReviews(
        context,
        vehicleId: vehicle.id,
        page: 1,
        limit: 10,
        clearBefore: true,
      );
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextBodyL(title: 'Review'),
         reviewViewModel.isLoading
        ? const Center(child: CircularProgressIndicator())
        :ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: reviewViewModel.reviews.length,
          itemBuilder: (context, index) {
            final review = reviewViewModel.reviews[index];

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
                                review.renter.imageAvatarUrl!,
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
                              review.renter.fullname,
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
                              "${review.createdAt}",
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
                    review.comment,
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
