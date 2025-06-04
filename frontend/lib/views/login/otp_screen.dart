import 'package:flutter/material.dart';
import 'package:frontend/views/login/newpassword_screen.dart';
import 'package:frontend/views/login/signIn_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:frontend/views/widgets/custom_alert_dialog.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final mode;
  const OtpScreen({super.key, required this.mode});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<AuthViewModel>(context, listen: true);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        color: Color(0xffF2F2F2),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
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
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/login/otp.png',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please enter the 5 digit code sent to',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff555658),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${viewmodel.email}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff212121),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 5,
                    controller: _otpController,
                    autoFocus: true,
                    animationType: AnimationType.none,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12),
                      fieldHeight: 60,
                      fieldWidth: 60,
                      borderWidth: 2,
                      inactiveColor: const Color(0xffA3A3B3),
                      activeColor: const Color(0xffF7F7F8),
                      selectedColor: const Color(0xff1976D2),
                      activeFillColor: const Color(0xffF7F7F8),
                      inactiveFillColor: const Color(0xffF7F7F8),
                      selectedFillColor: const Color(0xffF7F7F8),
                    ),
                    enableActiveFill: true,
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.length != 5) {
                        return 'Please enter the 5-digit code';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () {
                    viewmodel.verifyOTP(
                      viewmodel.email.toString(),
                      _otpController.text.trim().toString(),
                    );
                  },
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      color: const Color(0xFFEE463A),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFEE463A),
                      height: 1.29,
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Container(
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: Color(0xFF1976D2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      viewmodel.isLoading
                          ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFF7F7F8),
                              ),
                            ),
                          )
                          : CustomButton(
                            width: double.infinity,
                            title: 'Verify',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool isSuccess = await viewmodel.verifyOTP(
                                  viewmodel.email.toString(),
                                  _otpController.text.trim().toString(),
                                );
                                if (!context.mounted) return;
                                if (isSuccess) {
                                  if (widget.mode == "forgotPassword") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewPasswordScreen(),
                                      ),
                                    );
                                  } else if (widget.mode == "register") {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignInScreen(),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          title: 'Erorr',
                                          content:
                                              viewmodel.errorMessage ??
                                              'OTP verification failed. Please try again.',
                                          buttonText: 'OK',
                                        );
                                      },
                                    );
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => CustomAlertDialog(
                                          title: 'Error',
                                          content:
                                              'Please fill in all fields correctly.',
                                          buttonText: 'OK',
                                        ),
                                  );
                                }
                              }
                            },
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
