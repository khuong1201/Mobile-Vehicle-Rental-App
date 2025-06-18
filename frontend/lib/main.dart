import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
import 'package:frontend/viewmodels/auth/auth_viewmodel.dart';
import 'package:frontend/viewmodels/auth/google_auth_viewmodel.dart';
import 'package:frontend/viewmodels/booking/booking_viewmodel.dart';
import 'package:frontend/viewmodels/user/personal_information_viewmodel.dart';
import 'package:frontend/viewmodels/user/user_provider_viewmodel.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/views/home/home_page.dart';
import 'package:frontend/views/login/sign_in_screen.dart';
import 'package:frontend/views/splash_screen.dart';
import 'package:frontend/views/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
        ChangeNotifierProvider(create: (_) => UserViewModel()..loadUser()),
        Provider(create: (context) => AuthService(context)),
        ChangeNotifierProvider(
          create:
              (context) => VehicleViewModel(
                Provider.of<AuthService>(context, listen: false),
              ),
        ),
        ChangeNotifierProvider(create: (_) => PersonalInfoViewModel()),
        ChangeNotifierProvider(create: (_) => BookingViewModel()),
      ],
      child: MaterialApp(
        title: 'Vehicle Rental App',
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/home': (context) => const HomePage(),
          '/login': (context) => const SignInScreen(),
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('vi')],
      ),
    );
  }
}
