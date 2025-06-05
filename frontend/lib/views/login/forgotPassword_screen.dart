import 'package:flutter/material.dart';

import 'package:frontend/views/widgets/custom_text_form_field.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_alert_dialog.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                    'Forgot Password',
                    style: TextStyle(
                      color: Color(0xff212121),
                      fontSize: 28,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle:true,
                ),
                const SizedBox(height: 40),
                Image.asset('assets/images/login/Forgot password-amico 1.png',
                  width: 300,
                  height: 300
                ),
                const SizedBox(height: 40),
                Text('Please write your email to receive a confirmation code to set a new password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF555658),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.29,
                  ),
                ),
                const SizedBox(height: 40,),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email Address",
                        style: TextStyle(
                          color: Color(0xFF2B2B2C),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        hintText: "Enter your email",
                      ),
                    ],
                  )
                ),
                const SizedBox(height: 40),
                CustomButton(
                  width: double.infinity,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OtpScreen(mode: 'forgotPassword'))
                      );
                    } else {
                      showDialog(
                        context: context, 
                        builder: (context) => CustomAlertDialog(
                          title: 'Error', 
                          content: 'Please fill in all fields correctly.',
                          buttonText: 'OK',
                        )
                      );
                    }
                  },
                  title: 'Reset Password',
                )
              ]
            )
          )
        )
      )
    );
  }
}

