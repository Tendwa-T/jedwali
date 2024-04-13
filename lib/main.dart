import 'dart:convert';

import 'package:jedwali/controllers/fire_controller.dart';
import 'package:jedwali/firebase_options.dart';
import 'package:jedwali/utils/logger_utils.dart';
import 'package:jedwali/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
}

late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
JLogger logger = JLogger();

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    "high_Importance_Jedwali",
    "Jedwali High Importance",
    description: "A test channel for High importance Jedwali Notifications",
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  await flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification?.title,
    notification?.body,
    NotificationDetails(
      android: AndroidNotificationDetails(channel.id, channel.name,
          channelDescription: channel.description, icon: '@mipmap/ic_launcher'),
    ),
  );
}

void showLocalNoti(message) async {
  var decodedMessage = jsonDecode(message);
  try {
    print(decodedMessage);
    await flutterLocalNotificationsPlugin.show(
      1001,
      decodedMessage['notification']['title'],
      decodedMessage['notification']['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  } catch (e) {
    logger.errorLog("Failed to show Notification", e);
  }
}

void scheduleNotification() async {
  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1003,
      'Scheduled_jedwali',
      "This is a Scheduled Notification for Jedwali",
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  } catch (e) {
    Get.snackbar("Error", e.toString());
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FireController fireController = Get.put(FireController());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupFlutterNotifications();
  fireController.updateToken(await FirebaseMessaging.instance.getToken());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(showFlutterNotification);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    Get.toNamed("/");
  });
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Nairobi'));
  runApp(GetMaterialApp(
    themeMode: ThemeMode.system,
    title: "Jedwali",
    initialRoute: '/login',
    getPages: Routes.routes,
    debugShowCheckedModeBanner: false,
  ));
}
