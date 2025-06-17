import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/viewmodels/auth_viewmodel.dart';
import 'package:frontend/viewmodels/google_auth_viewmodel.dart';
import 'package:frontend/views/home/home_page.dart';
import 'package:frontend/views/login/otp_screen.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_alert_dialog.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';
import 'package:frontend/views/widgets/custom_text_body_M_sb.dart';
import 'package:provider/provider.dart';

import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final viewmodel = AuthViewModel();

  bool _isCheckedAgree = false;

  @override
  Widget build(BuildContext context) {
    final viewmodel = Provider.of<AuthViewModel>(context, listen: true);
    final gAuth = Provider.of<GAuthViewModel>(context, listen: true);
    return Scaffold(
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12),
        color: Color(0xffF2F2F2),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Text(
                  "Create Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff212121),
                    fontSize: 28,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Fill your information below or sign up with your social account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff808183),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.29,
                  ),
                ),
                const SizedBox(height: 28),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextBodyMsb(title: 'Name'),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        hintText: ('Enter your name'),
                      ),
                      const SizedBox(height: 12),
                      CustomTextBodyMsb(title: 'Email Address'),
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
                      const SizedBox(height: 12),
                      CustomTextBodyMsb(title: 'Password'),
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 12),
                      CustomTextBodyMsb(title: 'Confirm password'),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your confirm password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        hintText: "Confirm your Password",
                      ),
                      const SizedBox(height: 12),
                      FormField<bool>(
                        initialValue: _isCheckedAgree,
                        validator: (value) {
                          if (value != true) {
                            return 'You must agree to the Terms & Conditions';
                          }
                          return null;
                        },
                        builder: (formFieldState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: formFieldState.value,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isCheckedAgree = value!;
                                        formFieldState.didChange(value);
                                      });
                                    },
                                    visualDensity: VisualDensity(
                                      horizontal: -4,
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    side: BorderSide(
                                      color: Color(0xFFD5D7DB),
                                      width: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'I agree with ',
                                            style: TextStyle(
                                              color: Color(0xff212121),
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Term & Conditions',
                                            style: TextStyle(
                                              color: Color(0xFF1976D2),
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Color(
                                                0xFF1976D2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (formFieldState.hasError)
                                Center(
                                  child: Text(
                                    formFieldState.errorText ?? '',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
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
                                ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFF7F7F8),
                                    ),
                                  ),
                                )
                                : CustomButton(
                                  width: double.infinity,
                                  title: 'register',
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      bool isSuccess = await viewmodel.register(
                                        _emailController.text.trim().toString(),
                                        _confirmPasswordController.text
                                            .trim()
                                            .toString(),
                                        _nameController.text.trim().toString(),
                                      );
                                      if (!context.mounted) return;
                                      if (isSuccess) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => const OtpScreen(
                                                  mode: 'register',
                                                ),
                                          ),
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => CustomAlertDialog(
                                                title: 'Error',
                                                content:
                                                    viewmodel.errorMessage ??
                                                    'Registration failed. Please try again.',
                                                buttonText: 'OK',
                                              ),
                                        );
                                      }
                                    }
                                  },
                                ),
                      ),

                      const SizedBox(height: 28),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 1,
                              color: Color(0xFF555658),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Or sign up with',
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
                      ),
                      SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xffF7F7F8),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Color(0xFFDDDFE2),
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              icon: SvgPicture.asset(
                                'assets/images/login/google.svg',
                              ),
                              onPressed: () async {
                                final user = await gAuth.signInWithGoogle();
                                if (!context.mounted) return;
                                if (user != null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog(
                                      title: 'Success',
                                      content:
                                          'Account created successfully',
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => HomePage(),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => CustomAlertDialog(
                                          title: 'Error',
                                          content: 'Google sign in failed.',
                                          buttonText: 'OK',
                                        ),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xffF7F7F8),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Color(0xFFDDDFE2),
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              icon: SvgPicture.asset(
                                'assets/images/login/facebook.svg',
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
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
                                  builder: (context) => const SignInScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Color(0xFF1976D2),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 1.22,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF1976D2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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