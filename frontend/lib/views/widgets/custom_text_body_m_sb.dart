import 'package:flutter/material.dart';

class CustomTextBodyMsb extends StatelessWidget {
  final String title;
  final Color? color;
  const CustomTextBodyMsb({super.key, 
    // Key? key,
    required this.title,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: color ??Color(0xFF2B2B2C),
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
    );
  }
}
