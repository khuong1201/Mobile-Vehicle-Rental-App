import 'package:flutter/material.dart';

class CustomTextBodySsb extends StatelessWidget {
  final String title;

  const CustomTextBodySsb({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: const Color(0xFF808183),
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        height: 1.29,
      ),
    );
  }
}
