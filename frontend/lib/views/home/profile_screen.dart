import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen ({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}
class _ProfileScreen extends State<ProfileScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding:EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFEEFEF), 
                        ),
                        child: ClipOval(
                          child: Image.network(
                            '',                   //import anh gg
                            fit: BoxFit.contain,
                            width: 130,
                            height: 130,
                            errorBuilder: (context, error, stackTrace) => 
                              Image.asset(
                                'assets/images/home/error.png',
                                fit: BoxFit.contain,
                                width: 130,
                                height: 130,
                              ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('LinDa',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text( 
                      'linda01@gmai.com',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ),
                SizedBox(height: 44),
                Container(
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      _buildTitle('My account'),
                      SizedBox(height: 16),
                      _buildInkwellButton(context,'assets/images/home/profile/Personalnfo.svg', 'Personal Information', hasBorder: true),
                      _buildInkwellButton(context,'assets/images/home/profile/Address.svg', 'Address', hasBorder: true),
                      _buildInkwellButton(context,'assets/images/home/profile/StartHosting.svg', 'Start hosting'),
                    ],
                  )
                ),
                SizedBox(height: 44),
                Container(
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      _buildTitle('Settings'),
                      SizedBox(height: 16),
                      _buildInkwellButton(context,'assets/images/home/profile/Language.svg', 'Language', hasBorder: true),
                      _buildInkwellButton(context,'assets/images/home/profile/Currency.svg', 'Currency', hasBorder: true),
                      _buildInkwellButton(context,'assets/images/home/profile/TermsofService.svg', 'Terms of Service', hasBorder: true),
                      _buildInkwellButton(context,'assets/images/home/profile/PrivacyPolicy.svg', 'Privacy Policy', hasBorder: true),
                      _buildInkwellButton(context,'assets/images/home/profile/ChangePassword.svg', 'Change Password'),
                    ],
                  )
                ),
                SizedBox(height: 44),
                Container(
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      _buildTitle('Support'),
                      SizedBox(height: 16),
                      _buildInkwellButton(context,'assets/images/home/profile/EmergencyServices.svg', 'Emergency Services', hasBorder: true),
                      _buildInkwellButton(context,'assets/images/home/profile/Support.svg', '24/7 Customer Support', hasBorder: true),
                      _buildInkwellButton(context,'assets/images/home/profile/Feedback.svg', 'Send Feedback', hasBorder: true),
                      _buildInkwellButton(context,'assets/images/home/profile/Signout.svg', 'Sign out'),
                    ],
                  )
                ),
                SizedBox(height: 15)
              ]
            )
          )
        )
      )
    );
  }
}
Widget _buildTitle(String title){
  return Text(
    title,
    style: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
    ),
  );
}
Widget _buildInkwellButton (BuildContext context, String pathSvg, String label, {bool hasBorder = false, Widget? destination}) {
  return InkWell(
    onTap: destination != null 
    ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => destination,
          ),
        );
      }
    : null,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.only(bottom: 8, left: 16, right: 16),
      decoration: hasBorder == true
        ? const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFDDDFE2),
                width: 1,
              ),
            ),
          )
        : null,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              pathSvg,
            ),
          ),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.25,
            ),
          ),
          Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xff808183),
            ),
        ]
      )
    )
  );
}