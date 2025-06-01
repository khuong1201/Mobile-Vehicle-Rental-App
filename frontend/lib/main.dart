import 'package:flutter/material.dart';

import 'views/welcome_screen.dart';
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build (BuildContext context) {
    return MaterialApp(
      title: 'VehicleVehicle Rental App',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
