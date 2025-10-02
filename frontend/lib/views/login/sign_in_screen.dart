import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/viewmodels/auth/auth_viewmodel.dart';
import 'package:frontend/viewmodels/auth/google_auth_viewmodel.dart';
import 'package:frontend/views/widgets/custom_text_body_m_sb.dart';
import 'package:provider/provider.dart';

import 'package:frontend/views/widgets/custom_text_form_field.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_alert_dialog.dart';
import '../Home/home_page.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';

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
    final viewmodel = Provider.of<AuthViewModel>(context, listen: false);
    final gAuth = Provider.of<GAuthViewModel>(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: const Color(0xffFCFCFC),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 118),
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
                const SizedBox(height: 8),
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
                const SizedBox(height: 28),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextBodyMsb(title: "Email Address"),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email';
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Password';
                          }
                          if (value.length < 5) {
                            return 'Password must be at least 4 characters';
                          }
                          // final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).+$');
                          // if (!regex.hasMatch(value)) {
                          //   return 'Password must include upper, lower, number and special character';
                          // }
                          return null;
                        },
                        hintText: "Enter your Password",
                      ),
                      const SizedBox(height: 16),
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
                              const SizedBox(width: 8),
                              Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Color(0xff212121),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen(),
                                ),
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      CustomButton(
                        width: double.infinity,
                        title: 'Sign In',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool isSuccess = await viewmodel.login(
                              _emailController.text.trim().toString(),
                              _passwordController.text.trim().toString(),
                              rememberMe: _isCheckedRemember,
                            );
                            if (!context.mounted) return;
                            if (isSuccess) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => CustomAlertDialog(
                                      title: 'Log in Failed',
                                      content:
                                          viewmodel.errorMessage ??
                                          'Invalid email or password.',
                                      buttonText: 'OK',
                                    ),
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
                        },
                      ),
                      const SizedBox(height: 40),
                      Row(
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
                            'Or sign in with',
                            style: TextStyle(
                              color: Color(0xFF555658),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.29,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 40,
                            height: 1,
                            color: Color(0xFF555658),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
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
                              icon: SvgPicture.asset(
                                'assets/images/login/google.svg',
                              ),
                              onPressed: () async {
                                final user = await gAuth.signInWithGoogle();
                                if (!context.mounted) return;
                                if (user != null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
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
                          const SizedBox(width: 16),
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
                              icon: SvgPicture.asset(
                                'assets/images/login/facebook.svg',
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don’t have an account?',
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
                                ),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Color(0xfff1976d2),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 1.22,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xfff1976d2),
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
