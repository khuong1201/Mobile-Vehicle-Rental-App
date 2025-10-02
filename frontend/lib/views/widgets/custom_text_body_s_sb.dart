import 'package:flutter/material.dart';

class CustomTextBodySsb extends StatelessWidget {
  final String title;
  final TextOverflow? overflow;
  final int? maxLines;

  const CustomTextBodySsb({
    super.key,
    required this.title,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      overflow: overflow,
      style: const TextStyle(
        color: Color(0xFF808183),
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        height: 1.29,
      ),
    );
  }
}
