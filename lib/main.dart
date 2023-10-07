import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notification_course/screens/home_screen.dart';
import 'package:notification_course/services/notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.initializeLocalNotification(debug: true);
  // To listen to the notification overall when app is in background
  await NotificationController.initializeNotificationEventListners();
  // To listen to the notification click when app is terminated or killed
  // schedule microtask here is equivalent to the future delay .zero
  scheduleMicrotask(() async {
    await NotificationController.getInitialNotificationAction();
  });
  await NotificationController.initializeRemoteNotification(debug: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
