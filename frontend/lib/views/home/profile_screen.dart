import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
import 'package:frontend/viewmodels/user/role_viewmodel.dart';
import 'package:frontend/viewmodels/user/user_provider_viewmodel.dart';
import 'package:frontend/views/address/address_screen.dart';
import 'package:frontend/views/myAcount/driver_license_screen.dart';
import 'package:frontend/views/myAcount/infomation_screen.dart';
import 'package:frontend/views/widgets/custom_text_body_L.dart';
import 'package:provider/provider.dart';
import '/views/hosting/start_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userVM = Provider.of<UserViewModel>(context);
    final user = userVM.user;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color(0xffFCFCFC),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.network(
                          '',
                          fit: BoxFit.contain,
                          width: 130,
                          height: 130,
                          errorBuilder:
                              (context, error, stackTrace) => Image.asset(
                                'assets/images/error/avatar.png',
                                fit: BoxFit.contain,
                                width: 130,
                                height: 130,
                              ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        user?.fullName.isNotEmpty == true
                            ? user!.fullName
                            : 'Bro',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        user?.email.isNotEmpty == true ? user!.email : 'Bro',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 44),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextBodyL(title: 'My account'),
                      SizedBox(height: 16),
                      _buildInkwellButton(
                        context,
                        'assets/images/homePage/profile/Personalnfo.svg',
                        'Personal Information',
                        hasBorder: true,
                        destination: PersonalInfoScreen(),
                      ),
                      _buildInkwellButton(
                        context,
                        'assets/images/homePage/profile/Address.svg',
                        'Address',
                        hasBorder: true,
                        destination: AddressScreen(),
                      ),
                      _buildInkwellButton(
                        context,
                        'assets/images/homePage/profile/Driver_license.svg',
                        "Driver's license",
                        hasBorder: true,
                        destination: DriverLicenseScreen(),
                      ),
                      _buildInkwellButton(
                        context,
                        'assets/images/homePage/profile/StartHosting.svg',
                        'Start hosting',
                        onTap: () async {
                          final roleVM = context.read<RoleViewModel>();
                          final bool isOwner = await roleVM.checkRole();

                          if (!isOwner) {
                            await roleVM.updateUserRole(newRole: 'owner');

                            final message =
                                roleVM.successMessage ?? roleVM.errorMessage;
                            if (message != null) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(message)));
                            }
                          }

                          // Điều hướng
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StartScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 44),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextBodyL(title: 'Settings'),
                      SizedBox(height: 16),
                      _buildInkwellButton(
                        context,
                        'assets/images/homePage/profile/Language.svg',
                        'Language',
                        hasBorder: true,
                      ),
                      _buildInkwellButton(
                        context,
                        'assets/images/homePage/profile/Currency.svg',
                        'Currency',
                        hasBorder: true,
                      ),
                      _buildInkwellButton(
                        context,
                        'assets/images/homePage/profile/TermsofService.svg',
                        'Terms of Service',
                        hasBorder: true,
                      ),
                      _buildInkwellButton(
                        context,
                        'assets/images/homePage/profile/PrivacyPolicy.svg',
                        'Privacy Policy',
                        hasBorder: true,
                      ),
                      _buildInkwellButton(
                        context,
                        'assets/images/homePage/profile/ChangePassword.svg',
                        'Change Password',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 44),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextBodyL(title: 'Support'),
                      SizedBox(height: 16),
                      _buildInkwellButton(
                        context,
                        'assets/images/homePage/profile/EmergencyServices.svg',
                        'Emergency Services',
                        hasBorder: true,
                      ),
                      _buildInkwellButton(
                        context,
                        'assets/images/homePage/profile/Support.svg',
                        '24/7 Customer Support',
                        hasBorder: true,
                      ),
                      _buildInkwellButton(
                        context,
                        'assets/images/homePage/profile/Feedback.svg',
                        'Send Feedback',
                        hasBorder: true,
                      ),
                      _buildInkwellButton(
                        context,
                        'assets/images/homePage/profile/Signout.svg',
                        'Sign out',
                        onTap: () async {
                          final authService = AuthService(context);
                          await authService.logout();

                          Navigator.popUntil(
                            context,
                            ModalRoute.withName('/login'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildInkwellButton(
  BuildContext context,
  String pathSvg,
  String label, {
  VoidCallback? onTap,
  bool hasBorder = false,
  Widget? destination,
}) {
  return InkWell(
    onTap:
        onTap ??
        () {
          if (destination != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }
        },
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      margin: EdgeInsets.only(bottom: 8, left: 16, right: 16),
      decoration:
          hasBorder == true
              ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFDDDFE2), width: 1),
                ),
              )
              : null,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            child: SvgPicture.asset(pathSvg),
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
          Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xff808183)),
        ],
      ),
    ),
  );
}
