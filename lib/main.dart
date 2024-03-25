import 'dart:convert';

import 'package:Jedwali/controllers/class_data_controller.dart';
import 'package:Jedwali/controllers/fire_controller.dart';
import 'package:Jedwali/firebase_options.dart';
import 'package:Jedwali/notifications/notifications_service.dart';
import 'package:Jedwali/utils/logger_utils.dart';
import 'package:Jedwali/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:workmanager/workmanager.dart';

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
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification?.title,
    notification?.body,
    NotificationDetails(
      android: AndroidNotificationDetails(channel.id, channel.name,
          channelDescription: channel.description, icon: '@mipmap/ic_launcher'),
    ),
  );
}

void showLocalNoti(message) {
  var decodedMessage = jsonDecode(message);
  try {
    print(decodedMessage);
    flutterLocalNotificationsPlugin.show(
      1001,
      decodedMessage['notification']['title'],
      decodedMessage['notification']['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher'),
      ),
    );
  } catch (e) {
    logger.errorLog("Failed to show Notification", e);
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
  print(fireController.token.value);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(showFlutterNotification);
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    Get.toNamed("/");
  });
  runApp(GetMaterialApp(
    title: "Jedwali",
    initialRoute: '/login',
    getPages: Routes.routes,
    debugShowCheckedModeBanner: false,
  ));
}
