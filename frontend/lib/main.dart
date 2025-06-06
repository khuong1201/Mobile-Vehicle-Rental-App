import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/auth_viewmodel.dart';
import 'package:frontend/viewmodels/googleAuth_viewmodel.dart';
import 'package:provider/provider.dart';

import 'views/welcome_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => GAuthViewModel()),
      ],
      child: MaterialApp(
      title: 'VehicleVehicle Rental App',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    )
    );
  }
}
