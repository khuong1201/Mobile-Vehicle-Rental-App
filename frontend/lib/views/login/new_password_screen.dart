import 'package:flutter/material.dart';

import 'package:frontend/views/widgets/custom_alert_dialog.dart';
import 'package:frontend/views/widgets/custom_bottom_button.dart';
import 'package:frontend/views/widgets/custom_text_form_field.dart';
import 'sign_in_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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
                    'Create New Password',
                    style: TextStyle(
                      color: Color(0xff212121),
                      fontSize: 28,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/login/creatnewpassword.png',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 20),
                Text(
                  'Your New Password Must Be Different from Previously Used Password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff555658),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle("Password"),
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
                      const SizedBox(height: 16),
                      _buildTitle("Confirm new password"),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your confirm new password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        hintText: "Confirm Password",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  width: double.infinity,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) => CustomAlertDialog(
                          title: 'Go to sign in',
                          content: 'Password has been updated',
                          buttonText: 'Go to sign in',
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
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
                              content: 'Please fill in all fields correctly.',
                              buttonText: 'OK',
                            ),
                      );
                    }
                  },
                  title: 'Save',
                ),
                // Container(
                //   width: double.infinity,
                //   decoration: ShapeDecoration(
                //   color: Color(0xFF1976D2),
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                //   ),
                //   child: TextButton(
                //     onPressed: () {
                //       if (_formKey.currentState!.validate()) {
                //         //
                //         showDialog(
                //           context: context,
                //           builder: (context) {
                //             return AlertDialog(
                //               title: Text('Succes'),
                //               content: Text('Password has been updated'),
                //               actions: [
                //                 TextButton(
                //                   onPressed: () {
                //                     Navigator.pushReplacement(
                //                       context,
                //                       MaterialPageRoute(builder: (context) => SignInScreen())
                //                     );
                //                   },
                //                   child: Text('Go to sign in'),
                //                 ),
                //               ],
                //             );
                //           },
                //         );
                //       } else {
                //         showDialog(
                //           context: context,
                //           builder: (context) {
                //             return AlertDialog(
                //               title: Text('Error'),
                //               content: Text('Please fill in all fields correctly.'),
                //               actions: [
                //                 TextButton(
                //                   onPressed: () {
                //                     Navigator.of(context).pop();
                //                   },
                //                   child: Text('OK'),
                //                 ),
                //               ],
                //             );
                //           },
                //         );
                //       }
                //     },
                //     child: Text(
                //       'Save',
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //         color: Color(0xFFF7F7F8),
                //         fontSize: 18,
                //         fontFamily: 'Inter',
                //         fontWeight: FontWeight.w700,
                //         height: 1.22,
                //       ),
                //     )
                //   ),
                // ),
              ],
            ),
          ),
        ),
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
