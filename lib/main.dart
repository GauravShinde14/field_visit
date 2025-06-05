import 'package:field_visit/auth/notification_service.dart';
import 'package:field_visit/firebase_options.dart';
import 'package:field_visit/screens/Login_screen/login_screen.dart';
import 'package:field_visit/screens/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print("Background Message: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: NotificationService.instance.navigatorKey,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen());
  }
}
