import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen ({super.key});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(4),
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        title: Text(
          'Verify your email',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,  
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
            Color(0xFF1A1A40),
            Color(0xFFD1D1D9)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/login/otp.png',
                  width: 300,
                  height: 300,
                ),
                SizedBox(height: 16,),
                Text('Please enter the 4 digit code sent to',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 8),
                Text('abcdhc@gmail.com',  //import ten gmail
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16),
                Form(
                  key:_formKey,
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
                    fieldHeight: 50,
                    fieldWidth: 50,
                    inactiveColor: Colors.grey.shade300,
                    activeColor: Colors.grey.shade300,
                    selectedColor: Colors.blueAccent,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                  ),
                  enableActiveFill: true,
                  onChanged: (value) {},
                  ),
                ),
                SizedBox(height: 40),
                TextButton(
                  onPressed: () {

                  },
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      color: const Color(0xFFEE4639),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFEE4639),
                      height: 1.29,
                    ),
                  )
                ),
                SizedBox(height: 60),
                Container(
                  width: double.infinity,
                  decoration: ShapeDecoration(
                  color: Color(0xFFFFD700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => NewPasswordScreen())
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
                      'Verify',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1A1A40),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.22,
                      ),
                    )
                  ),
                ),
              ],
            )
          )
        ),
      )
    );
  }
}


class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(4),
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        title: Text(
          'Create New Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
            Color(0xFF1A1A40),
            Color(0xFFD1D1D9)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/login/creatnewpassword.png',
                  width: 300,
                  height: 300
                ),
                SizedBox(height: 40,),
                Text('Your New Password Must Be Different from Previously Used Password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 20,),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                          color: Color(0xFFEAEBED),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: TextStyle(
                            color: Color(0xFFEAEBED),
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1.29,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFC1C2CA),
                              width: 1,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Color(0xFFEAEBED),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value){
                          if (value == null || value.isEmpty){
                            return 'Please enter your password';
                          }
                          return null;
                        }
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Confirm new password",
                        style: TextStyle(
                          color: Color(0xFFEAEBED),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          hintText: "Confirm new password",
                          hintStyle: TextStyle(
                            color: Color(0xFFEAEBED),
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1.29,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFC1C2CA),
                              width: 1,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              color: Color(0xFFEAEBED),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value){
                          if (value == null || value.isEmpty){
                            return 'Please enter your confirm new password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        }
                      ),
                    ],
                  )
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  decoration: ShapeDecoration(
                  color: Color(0xFFFFD700),
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
                      'Save',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1A1A40),
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
