import 'package:flutter/material.dart';

class CustomTextHeading4 extends StatelessWidget {
  final String title;

  const CustomTextHeading4({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
