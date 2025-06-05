// import 'dart:convert';

// import 'package:field_visit/screens/notification_screen/notification_screen.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// // class NotificationService {
// //   static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();

// //   static Future<void> initialize() async {
// //     const AndroidInitializationSettings androidSettings =
// //         AndroidInitializationSettings('@mipmap/ic_launcher');

// //     const InitializationSettings settings = InitializationSettings(
// //       android: androidSettings,
// //     );

// //     await _localNotificationsPlugin.initialize(settings);
// //   }

// //   static Future<void> showNotification(RemoteMessage message) async {
// //     const AndroidNotificationDetails androidDetails =
// //         AndroidNotificationDetails(
// //       'high_importance_channel',
// //       'High Importance Notifications',
// //       importance: Importance.max,
// //       priority: Priority.high,
// //     );

// //     const NotificationDetails notificationDetails =
// //         NotificationDetails(android: androidDetails);

// //     await _localNotificationsPlugin.show(
// //       0,
// //       message.notification?.title ?? "No Title",
// //       message.notification?.body ?? "No Body",
// //       notificationDetails,
// //     );
// //   }
// // }

// // below this its working code for notification but ontap not going to particluar screen.
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await NotificationService.intance.setupFlutterNotifications();
//   await NotificationService.intance.showNotification(message);
// }

// class NotificationService {
//   NotificationService._();
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//   static final NotificationService intance = NotificationService._();

//   final _messaging = FirebaseMessaging.instance;
//   final _localNotifications = FlutterLocalNotificationsPlugin();
//   bool _isFlutterLocalNotificationsInitilized = false;
//   // static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

//   Future<void> initialize() async {
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     await _requestPermission();
//     await _setupMessageHandlers();
//     final fcmtoken = await _messaging.getToken();
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     // prefs.setString("fcmtoken", fcmtoken.toString());
//     // Auth().sendTokenToBackend(fcmtoken);
//     print("FCM Token: $fcmtoken");
//   }

//   Future<String?> getFcmToken() async {
//     // Retrieve and return the FCM token
//     return await _messaging.getToken();
//   }

//   Future<void> _requestPermission() async {
//     final settings = await _messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     print("Permission Status:${settings.authorizationStatus}");
//   }

//   Future<void> setupFlutterNotifications() async {
//     if (_isFlutterLocalNotificationsInitilized) {
//       return;
//     }
//     const channel = const AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'High Importance Notifications', // title
//       description:
//           'This channel is used for important notifications.', // description
//       importance: Importance.high,
//     );

//     /// Create an Android Notification Channel.
//     ///
//     /// We use this channel in the `AndroidManifest.xml` file to override the
//     /// default FCM channel to enable heads up notifications.
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     const initializationSettingsAndroid =
//         AndroidInitializationSettings("@mipmap/ic_launcher");

//     const DarwinInitializationSettings darwinSettings =
//         DarwinInitializationSettings();

//     const InitializationSettings settings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: darwinSettings,
//     );

//     await _localNotifications.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         print("Notification tapped: ${response.payload}");

//         // Handle notification tap
//         // _handleNotificationTap(response.payload);
//       },
//     );

//     /// Update the iOS foreground notification presentation options to allow
//     /// heads up notifications.
//     // await FirebaseMessaging.instance
//     //     .setForegroundNotificationPresentationOptions(
//     //   alert: true,
//     //   badge: true,
//     //   sound: true,
//     // );
//     _isFlutterLocalNotificationsInitilized = true;
//   }

//   //  void _handleNotificationTap(String? payload) {
//   //   if (payload != null) {
//   //     navigatorKey.currentState?.push(
//   //       MaterialPageRoute(builder: (context) => AppointmentScreen()),
//   //     );
//   //   }
//   // }

//   Future<void> showNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     if (notification != null && android != null) {
//       await _localNotifications.show(
//         0,
//         message.notification?.title ?? "No Title",
//         message.notification?.body ?? "No Body",
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'high_importance_channel',
//             'High Importance Notifications',
//             importance: Importance.max,
//             priority: Priority.high,
//             icon: '@mipmap/ic_launcher',
//           ),
//         ),
//         //  payload: "appointment_screen",
//       );
//     }
//   }

//   Future<void> _setupMessageHandlers() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Foreground notification received: ${message.notification?.title}");

//       // Show local notification using flutter_local_notifications
//       showNotification(message);
//     });

// //background meaasge
//     // FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _handleNotificationTap();
//     });
// //opened app

//     //   final initialMessage = await _messaging.getInitialMessage();
//     //   if (initialMessage != null) {
//     //     _handleBackgroundMessage(initialMessage);
//     //   }
//     // }
//     final initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       _handleNotificationTap();
//     }
//   }

//   void _handleBackgroundMessage(RemoteMessage message) {}
//   void _handleNotificationTap() {
//     navigatorKey.currentState?.push(
//       MaterialPageRoute(builder: (_) => const NotificationScreen()),
//     );
//   }
// }

import 'package:field_visit/screens/notification_screen/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _requestPermission();
    await setupFlutterNotifications();
    await _setupMessageHandlers();

    final fcmtoken = await _messaging.getToken();
    print("FCM Token: $fcmtoken");
  }

  Future<String?> getFcmToken() async {
    // Retrieve and return the FCM token
    return await _messaging.getToken();
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print("Permission Status: ${settings.authorizationStatus}");
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        _handleNotificationTap();
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        0,
        notification.title ?? 'No Title',
        notification.body ?? 'No Body',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground notification received: ${message.notification?.title}");
      showNotification(message);
    });

    // Background (when app is in background and user taps)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });

    // Terminated (cold start)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      // Handle cold start tap
      Future.delayed(Duration.zero, () {
        _handleNotificationTap(initialMessage);
      });
    }
  }

  void _handleNotificationTap([RemoteMessage? message]) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => const NotificationScreen()),
    );
  }
}
