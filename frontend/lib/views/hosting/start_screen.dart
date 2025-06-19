import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/views/hosting/lessor_home_screen.dart';

import 'package:frontend/views/widgets/custom_appbar.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_text_heading4.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});
  @override
  State<StartScreen> createState() => _StartScreen();
}

class _StartScreen extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Start Hosting'),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment:MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/images/hosting/start/startHosting.png',
              width: 350,
              height: 270,
            ),
            Container(
              child: Column(
                children: [
                  CustomTextHeading4(title: 'Steps To Register '),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSvg(
                          'assets/images/hosting/start/Information.svg',
                          'Vehical Information',
                        ),
                        SizedBox(height: 24),
                        _buildSvg(
                          'assets/images/hosting/start/Image.svg',
                          'Download Car Image',
                        ),
                        SizedBox(height: 24),
                        _buildSvg(
                          'assets/images/hosting/start/Consulting.svg',
                          'Consulting And Car Review',
                        ),
                        SizedBox(height: 24),
                        _buildSvg(
                          'assets/images/hosting/start/Start renting.svg',
                          'Start renting',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(16),
        child: CustomButton(
          width: double.infinity,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessorHomeScreen()
              ),
            );
          },
          title: 'Start hosting',
        ),
      ),
    );
  }
}

Widget _buildSvg(String pathSvg, String title) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(width: 24, height: 24, child: SvgPicture.asset(pathSvg)),
      SizedBox(width: 14),
      Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          height: 1.29,
        ),
      ),
    ],
  );
}
