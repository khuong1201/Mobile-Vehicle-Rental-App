import 'package:flutter/material.dart';

import '../widgets/custom_bottom_button.dart';
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});
  @override
  State<StartScreen> createState() => _StartScreen();
}

class _StartScreen extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffD1E4F6),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.arrow_back, color: Color(0xff1976D2)),
                ),
              ),
              title: Text(
                'Verify your email',
                style: TextStyle(
                  color: Color(0xff212121),
                  fontSize: 28,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            Image.asset('assets/images/login/otp.png', width: 300, height: 300),
            SizedBox(height: 36),
            Text(
              'Increase your monthly income with us',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.17,
              ),
            ),
            CustomButton(
              onPressed:(){

              },
              title:'Start hosting'
            )
          ],
        ),
      ),
    );
  }
}
