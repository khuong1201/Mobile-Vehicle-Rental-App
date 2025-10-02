import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:frontend/views/home/home_page.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'package:frontend/api_services/notification_service.dart';
import 'package:frontend/viewmodels/fcm_viewmodel.dart';
import 'package:frontend/views/splash_screen.dart';
import 'package:frontend/views/welcome_screen.dart';

import 'package:frontend/views/login/sign_in_screen.dart';
import 'package:frontend/views/booking/confirmation_screen.dart';
import 'package:frontend/views/hosting/booking_info.dart';
import 'package:frontend/viewmodels/booking/booking_viewmodel.dart';
import 'package:frontend/viewmodels/auth/auth_service.dart';
import 'package:frontend/viewmodels/auth/auth_viewmodel.dart';
import 'package:frontend/viewmodels/auth/google_auth_viewmodel.dart';
import 'package:frontend/viewmodels/user/user_provider_viewmodel.dart';
import 'package:frontend/viewmodels/user/personal_information_viewmodel.dart';
import 'package:frontend/viewmodels/user/role_viewmodel.dart';
import 'package:frontend/viewmodels/user/user_license_viewmodel.dart';
import 'package:frontend/viewmodels/vehicle/vehicle_viewmodel.dart';
import 'package:frontend/viewmodels/vehicle/review_viewmodel.dart';
import 'package:frontend/viewmodels/location/location_viewmodel.dart';
import 'package:intl/date_symbol_data_local.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('📩 Background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('vi');
  await NotificationService().init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => GAuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => AuthService(context)),
        ChangeNotifierProvider(
          create: (context) => VehicleViewModel(context.read<AuthService>()),
        ),
        ChangeNotifierProvider(create: (_) => PersonalInfoViewModel()),
        ChangeNotifierProvider(
          create: (context) => UserLicenseViewModel(
            authService: context.read<AuthService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewViewModel(context.read<AuthService>()),
        ),
        ChangeNotifierProvider(create: (_) => LocationViewModel()),
        ChangeNotifierProvider(
          create: (context) =>
              RoleViewModel(authService: context.read<AuthService>()),
        ),
        ChangeNotifierProvider(create: (context) => BookingViewModel()),
        ChangeNotifierProvider(create: (_) => FCMViewModel()),
      ],
      child: const RootApp(),
    ),
  );
}

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
    _initFCM();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthService>().loadUser();
    });
  }

  void _initFCM() async {
    final fcmService = NotificationService();
    final fcmVM = context.read<FCMViewModel>();
    fcmVM.initFCM();

    // Foreground
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('📨 Foreground message: ${message.notification?.title}');
      final title = message.notification?.title ?? 'Thông báo mới';
      final body = message.notification?.body ?? '';
      // Khi foreground: show local notification
      fcmService.showNotification(
        title: title,
        body: body,
        payload: message.data,
      );
    });

    // Background / tapped notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNotificationClick(message.data);
    });

    // Terminated app
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage.data);
    }
  }

  void _handleNotificationClick(Map<String, dynamic> data) {
    final type = data['type'];
    debugPrint('📬 Notification click data: $data');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (type) {
        case 'bookingByRental':
          final bookingId = data['bookingId'];
          final vehicleId = data['vehicleId'];
          if (bookingId != null && vehicleId != null) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (_) => BookingInfomation(
                  bookingId: bookingId,
                  vehicleId: vehicleId,
                ),
              ),
            );
          }
          break;

        // case 'bookingAccepted':
        //   final bookingId = data['bookingId'];
        //   if (bookingId != null) {
        //     navigatorKey.currentState?.push(
        //       MaterialPageRoute(
        //         builder: (_) => Confirmationscreen(
        //           vehicle: context.read<BookingViewModel>().selectedVehicle!,
        //         ),
        //       ),
        //     );
        //   }
        //   break;
        default:
          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (_) => HomePage()),
          );
      }
    });
  }

  void _initDeepLinks() {
    _appLinks = AppLinks();
    _sub = _appLinks.uriLinkStream.listen(
      (uri) {
        try {
          if (uri.scheme == 'vehiclerental' && uri.host == 'payment-success') {
            final vehicle = context.read<BookingViewModel>().selectedVehicle;
            if (vehicle != null) {
              navigatorKey.currentState?.push(
                MaterialPageRoute(
                  builder: (_) => Confirmationscreen(vehicle: vehicle),
                ),
              );
            }
          }
        } catch (e) {
          debugPrint('❌ Deep link error: $e');
        }
      },
      onError: (err) => debugPrint('❌ Deep link stream error: $err'),
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Vehicle Rental App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const SignInScreen(),
      },
      supportedLocales: const [Locale('en', 'vi')],
    );
  }
}
