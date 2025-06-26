import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/viewmodels/vehicle/review_viewmodel.dart';
import 'package:frontend/views/widgets/custom_text_body_L.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatelessWidget {
  final Vehicle vehicle;
  const ReviewScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final reviewViewModel = Provider.of<ReviewViewModel>(
      context,
      listen: false,
    );
    final TextEditingController _comment = TextEditingController();

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
            : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: reviewViewModel.reviews.length,
              itemBuilder: (context, index) {
                final review = reviewViewModel.reviews[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 8),
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
                                        (context, error, stackTrace) =>
                                            Image.asset(
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
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: "Bình luận",
                controller: _comment,
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () async {
                if (_comment.text.trim().isNotEmpty) {
                  // Hiển thị dialog chọn số sao
                  int? selectedRating = await showDialog<int>(
                    context: context,
                    builder: (BuildContext context) {
                      int rating = 0;
                      return AlertDialog(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical:16 ),
                        title: const Text(
                          'Rate',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        content: StatefulBuilder(
                          builder: (
                            BuildContext context,
                            StateSetter setState,
                          ) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      rating = index + 1;
                                    });
                                  },
                                  child: Icon(
                                    Icons.star,
                                    color:
                                        index < rating
                                            ? Colors.amber
                                            : Colors.grey,
                                    size: 30,
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Color(0xff1976D2),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (rating > 0) {
                                Navigator.of(context).pop(rating);
                              }
                            },
                            child: const Text(
                              'Accep',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Color(0xff1976D2),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  // Gửi bình luận nếu có rating được chọn
                  if (selectedRating != null) {
                    final reviewViewModel = Provider.of<ReviewViewModel>(
                      context,
                      listen: false,
                    );
                    final vehicle = Provider.of<Vehicle>(
                      context,
                      listen: false,
                    ); 
                    final commentText = _comment.text.trim();

                    bool success = await reviewViewModel.createReview(
                      context,
                      vehicleId: vehicle.id,
                      rating: selectedRating,
                      comment: commentText,
                    );

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đánh giá đã được gửi thành công!')),
                      );
                      _comment.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi: ${reviewViewModel.errorMessage ?? 'Không thể gửi đánh giá'}')),
                      );
                    }
                    print(
                      'Gửi bình luận lúc: ${DateTime.now()} - Vehicle ID: ${vehicle.id}, Rating: $selectedRating, Comment: $commentText, Success: $success',
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vui lòng nhập bình luận trước khi gửi!'),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.send_rounded,
                size: 20,
                color: Color(0xff1976D2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
