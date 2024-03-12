import 'package:Jedwali/controllers/class_data_controller.dart';
import 'package:Jedwali/notifications/notifications_service.dart';
import 'package:Jedwali/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

ClassesController _controller = Get.put(ClassesController());

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    String className = inputData?["className"] ?? "Unknown class";
    String location = inputData?["location"] ?? "Unknown location";
    String cCode = inputData?["code"] ?? "TST-00-";
    await showClassNotification(
      "Class Reminder ⏰ $cCode",
      "$className at $location",
    );
    return Future.value(true);
  });
}

Future<void> showNotification() async {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    "0000",
    "Jedwali Notifications",
    channelDescription: "Test Channel ",
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    "Jedwali Notification",
    "Test notification ",
    platformChannelSpecifics,
  );
}

Future<void> showClassNotification(String title, String body) async {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    "Class-000CH",
    "Class Notification - Test",
    channelDescription: "The official Class Test Channel ",
    importance: Importance.max,
    priority: Priority.high,
  );

  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
  );
}

void scheduleClassNotificationWorker(
    String className, String location, String code) {
  Workmanager().registerOneOffTask(
    "Class-notifications",
    "Jedwali: Class notifications",
    inputData: {
      "className": className,
      "location": location,
      "code": code,
    },
    initialDelay: const Duration(seconds: 1),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(GetMaterialApp(
    title: "Jedwali",
    initialRoute: '/login',
    getPages: Routes.routes,
    debugShowCheckedModeBanner: false,
  ));
}
