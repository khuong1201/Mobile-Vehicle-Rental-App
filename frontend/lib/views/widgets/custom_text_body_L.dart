import 'package:flutter/material.dart';

class CustomTextBodyL extends StatelessWidget {
  final String title;

  const CustomTextBodyL({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
