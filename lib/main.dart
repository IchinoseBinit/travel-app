import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:injectable/injectable.dart';
import 'package:travel_app/presentation/pages/home/home.dart';
import 'package:travel_app/presentation/pages/map/osm_map.dart';
import 'package:travel_app/presentation/pages/map/sample_map.dart';
import 'package:travel_app/presentation/pages/splash/splash_page.dart';
import 'package:travel_app/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/routes/navigation_service.dart';
import 'config/routes/route_generator.dart';
import 'config/routes/routes.dart';
import 'injection.dart';
import 'presentation/pages/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureInjection(Environment.dev);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  configureMessaging() async {
    final messagingInstance = FirebaseMessaging.instance;
    final permission = await messagingInstance.requestPermission();

    // messagingInstance.
    FirebaseMessaging.onMessage.forEach(
      (event) {
        const androidNotification = AndroidNotificationDetails(
          "channel id",
          "channel name",
          importance: Importance.high,
          priority: Priority.high,
        );

        const notificationDetails =
            NotificationDetails(android: androidNotification);

        flutterLocalNotificationsPlugin.show(
          Random().nextInt(100000),
          event.notification?.title ?? "title",
          event.notification?.body ?? "body",
          notificationDetails,
        );
        // event.
        // print("object");
        // print(event.notification?.title ?? "title");
        // print(event.notification?.body ?? "messageBody");
        // print(event.notification?.android?.imageUrl ?? "imageUrl");
      },
    );
  }

  configureNotification() {
    const androidSettings =
        AndroidInitializationSettings("/mipmap/ic_launcher");
    const iosSettings = IOSInitializationSettings();

    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    configureNotification();
    configureMessaging();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TwoPointO',
      initialRoute: Routes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      navigatorKey: getIt<NavigationService>().navigatorKey,
      theme: themeDate,
      // home: Home(),
      // home: WelcomeScreen(),
      home: SplashPage(),
      // home: MapSample(),
      // home: MapSample(),
    );
  }
}
