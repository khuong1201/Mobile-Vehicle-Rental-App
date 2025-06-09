import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/google_auth_viewmodel.dart';
import 'package:frontend/views/home/home_screen.dart';
import 'package:frontend/views/hosting/start_screen.dart';
import 'package:frontend/views/login/sign_in_screen.dart';
import 'package:provider/provider.dart';
import '/viewmodels/auth_viewmodel.dart';
import '/views/splash_screen.dart';
import '/views/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        title: 'Vehicle Rental App',
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        home: const StartScreen(),
        // routes: {
        //   '/splash': (context) => const SplashScreen(),
        //   '/welcome': (context) => const WelcomeScreen(),
        //   '/home': (context) => const HomeScreen(),
        //   '/login': (context) => const SignInScreen(),
        // },
      ),
    );
  }
}