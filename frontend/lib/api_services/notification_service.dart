import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:frontend/views/hosting/booking_info.dart';
import '../main.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;
        if (payload != null && payload.contains(',')) {
          final parts = payload.split(',');
          final bookingId = parts[0];
          final vehicleId = parts[1];
          if (navigatorKey.currentState != null) {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (_) => BookingInfomation(
                  bookingId: bookingId,
                  vehicleId: vehicleId,
                ),
              ),
            );
          }
        }
      },
    );
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? bookingId,
    String? vehicleId, required Map<String, dynamic> payload,
  }) async {
    final payload = (bookingId != null && vehicleId != null)
        ? '$bookingId,$vehicleId'
        : null;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(0, title, body, details, payload: payload);
  }
}
