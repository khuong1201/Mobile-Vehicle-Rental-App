import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/auth/check_login_status.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLoginStatus(context);
    });
    return const Scaffold(
      body: Center(),
    );
  }
}