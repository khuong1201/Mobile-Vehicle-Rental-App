import 'package:flutter/material.dart';

class BannerSlider extends StatelessWidget {
  final List<String> banners;
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const BannerSlider({
    super.key,
    required this.banners,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 29),
      height: 220,
      child: PageView.builder(
        controller: controller,
        itemCount: banners.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(banners[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
