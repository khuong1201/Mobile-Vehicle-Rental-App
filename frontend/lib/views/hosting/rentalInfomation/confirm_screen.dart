  import 'package:flutter/material.dart';
import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_text_body_l.dart';

class CofirmScreen extends StatelessWidget {
  const CofirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'List Your Vehicle',
        textColor: Color(0xFFFFFFFF),
        height: 80,
        backgroundColor: Color(0xFF1976D2),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        height: double.infinity,
        width: double.infinity,
        color: Color(0xffFDFDFD),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/hosting/information/email_marketing_and_promotion-removebg-preview 1.svg',
              width: 320,
              height: 200,
            ),
            CustomTextBodyL(title: 'Your request is being reviewed. '),
            const SizedBox(height:4),
            CustomTextBodyL(title: 'Your request is being reviewed. ')
          ],
        )
      )
    );
  }
}