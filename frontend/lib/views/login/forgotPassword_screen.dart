import 'package:flutter/material.dart';

import 'widgets/custom_text_field.dart';
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
                SizedBox(height: 40),
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
                SizedBox(height: 40),
                Image.asset('assets/images/login/Forgot password-amico 1.png',
                  width: 300,
                  height: 300
                ),
                SizedBox(height: 40,),
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
                SizedBox(height: 40,),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email Address",
                        style: TextStyle(
                          color: Color(0xFFEAEBED),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 8),
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
                SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  decoration: ShapeDecoration(
                  color: Color(0xFF1976D2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => OtpScreen())
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Please fill in all fields correctly.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      'Reset Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF7F7F8),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.22,
                      ),
                    )
                  ),
                ),
              ]
            )
          )
        )
      )
    );
  }
}

