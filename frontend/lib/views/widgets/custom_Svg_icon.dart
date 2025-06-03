import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconTextButton extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  const SvgIconTextButton({
    super.key,
    required this.assetPath,
    required this.label,
    required this.onPressed,
    this.width,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          SvgPicture.asset(
            assetPath,
            width: width,
            height: height,
          ),
          SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF2B2B2C),
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
