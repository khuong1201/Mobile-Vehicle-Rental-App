import 'package:flutter/material.dart';
import 'package:frontend/views/widgets/custom_text_heading4.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/hosting/Lessorhome/empty.png',
            width: 350,
            height: 250,
          ),
          CustomTextHeading4(title: "You don't have a car yet")
        ],
      ),
    );
  }
}