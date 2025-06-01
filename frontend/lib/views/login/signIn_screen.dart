import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'widgets/custom_text_form_field.dart';
import '../home/homePage.dart';
import 'signUp_screen.dart';
import 'forgotPassword_screen.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isCheckedRemember = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: Color(0xffF2F2F2),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height:118),
                Text(
                  "Sign In",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff212121),
                    fontSize: 28,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Hi! Welcome back, you’re been missed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff808183),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.29,
                  ),
                ),
                SizedBox(height: 28),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle("Email Address"),
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
                      SizedBox(height: 12),
                      _buildTitle('Password'),
                      SizedBox(height: 8),
                      CustomTextField(
                        controller: _passwordController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Password';
                          }
                          return null;
                        },
                        hintText: "Enter your Password",
                      ),
                      SizedBox(height: 16,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _isCheckedRemember,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isCheckedRemember = value!;
                                  });
                                },
                                visualDensity: VisualDensity(horizontal: -4),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                side: BorderSide(
                                  color: Color(0xFFD5D7DB),
                                  width: 2,             
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Color(0xff212121),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ]
                          ),
                          TextButton(
                            onPressed: (){
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => ForgotPasswordScreen())
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color(0xFF1976D2),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF1976D2),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  child: Column(
                    children: [
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
                                MaterialPageRoute(builder: (context) => HomePage())
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
                            'Sign In',
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
                      SizedBox(height: 40),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 1,
                            color: Color(0xFF555658),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Or sign in with',
                            style: TextStyle(
                              color: Color(0xFF555658),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.29,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 40,
                            height: 1,
                            color: Color(0xFF555658),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xffEAEBED),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Color(0xFFD1D1D9),
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              icon: SvgPicture.asset('assets/images/login/google.svg'),
                              onPressed: () {
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xffEAEBED),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Color(0xFFD1D1D9),
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              icon: SvgPicture.asset('assets/images/login/facebook.svg'),
                              onPressed: () {
                              },
                            ),
                          ),
                        ]
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          Text('Don’t have an account?',
                            style: TextStyle(
                            color: Color(0xFF555658),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,  
                              height: 1.25,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                )
                              );
                            },
                            child: Text(
                            'Sign Up',
                              style: TextStyle(
                                color: Color(0xFFF1976D2),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 1.22,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFFF1976D2),
                              ),
                            )
                          )
                        ],
                      )
                    ],
                  ),
                )
              ]
            )
          )
        )
      ),
    );
  }
}

Widget _buildTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      color: Color(0xFF2B2B2C),
      fontSize: 16,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),
  );
}