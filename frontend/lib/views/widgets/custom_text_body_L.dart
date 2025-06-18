import 'package:flutter/material.dart';

class CustomTextBodyL extends StatelessWidget {
  final String title;
  final Color? textColor;

  const CustomTextBodyL({super.key, required this.title, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: textColor ?? Colors.black,
        fontSize: 18,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
