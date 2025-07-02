import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/models/vehicles/vehicle.dart';
import 'package:frontend/viewmodels/vehicle/review_viewmodel.dart';
import 'package:frontend/views/widgets/custom_text_body_l.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  final Vehicle vehicle;

  const ReviewScreen({
    super.key,
    required this.vehicle,
  });

  @override
  State<ReviewScreen> createState() => ReviewScreenState();
}

class ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _comment = TextEditingController();

  Future<void> fetchData() async {
    final reviewViewModel = context.read<ReviewViewModel>();
    await reviewViewModel.fetchReviews(
      context,
      vehicleId: widget.vehicle.id,
      page: 1,
      limit: 10,
      clearBefore: true,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return 
    Consumer<ReviewViewModel>(
      builder: (context, reviewViewModel, _) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextBodyL(title: 'Review'),
              const SizedBox(height: 16,),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: "Bình luận",
                      controller: _comment,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () async {
                      if (_comment.text.trim().isNotEmpty) {
                        int? selectedRating = await showRatingDialog(context);
                        if (selectedRating != null) {
                          final reviewViewModel =
                              Provider.of<ReviewViewModel>(context, listen: false);

                          final commentText = _comment.text.trim();
                          bool success = await reviewViewModel.createReview(
                            context,
                            vehicleId: widget.vehicle.id,
                            rating: selectedRating,
                            comment: commentText,
                          );

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đánh giá đã được gửi thành công!')),
                            );
                            _comment.clear();
                            await reviewViewModel.fetchReviews(
                              context,
                              vehicleId: widget.vehicle.id,
                              page: 1,
                              limit: 10,
                              clearBefore: true,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Lỗi: ${reviewViewModel.errorMessage ?? 'Không thể gửi đánh giá'}'),
                              ),
                            );
                          }
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
              reviewViewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : reviewViewModel.reviews.isEmpty
                      ? const Center(child: Text('Chưa có đánh giá nào.'))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviewViewModel.reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviewViewModel.reviews[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFE5E5E5),
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
                                      Row(
                                        children: [
                                          ClipOval(
                                            child: Image.network(
                                              review.renter.imageAvatarUrl ?? '',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Image.asset(
                                                'assets/images/error/avatar.png',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            review.renter.fullName,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700,
                                              height: 1.29,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/vehicle_detail/time.svg',
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}",
                                            style: const TextStyle(
                                              color: Color(0xFF808183),
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 1.29,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    review.comment,
                                    style: const TextStyle(
                                      color: Color(0xFF808183),
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
          ),
        );
      },
    );
  }

  Future<int?> showRatingDialog(BuildContext context) {
    int rating = 0;
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          title: const Text(
            'Đánh giá',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Row(
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
                      color: index < rating ? Colors.amber : Colors.grey,
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
                'Hủy',
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
                'Đồng ý',
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
  }
}
