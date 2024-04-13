import 'dart:convert';

import 'package:jedwali/configs/constants.dart';
import 'package:jedwali/controllers/class_data_controller.dart';
import 'package:jedwali/controllers/fire_controller.dart';
import 'package:jedwali/main.dart';
import 'package:jedwali/utils/logger_utils.dart';
import 'package:jedwali/views/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class TimerWidget extends StatelessWidget {
  final ClassesController _controller = Get.find<ClassesController>();
  final FireController fireController = Get.find<FireController>();
  JLogger logger = JLogger();

  TimerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClassesController>(
        init: ClassesController(),
        builder: (controller) {
          return Container(
            width: 379,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color.fromRGBO(108, 99, 255, 1),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () {
                      if (controller.lessons.isEmpty) {
                        return const SizedBox();
                      } else {
                        return const Text(
                          "Next class in: ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () {
                      if (controller.lessons.isEmpty) {
                        return const Center(
                          child: Text(
                            "No Upcoming class",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      } else {
                        return TimerCountdown(
                          format: CountDownTimerFormat.daysHoursMinutesSeconds,
                          timeTextStyle: const TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                          ),
                          descriptionTextStyle: const TextStyle(
                            color: appWhite,
                          ),
                          colonsTextStyle: const TextStyle(
                            color: Colors.white70,
                            fontSize: 40,
                          ),
                          endTime: DateTime.now().add(_controller.toNext.value),
                          onEnd: () async {
                            bool isConnected =
                                await InternetConnection().hasInternetAccess;
                            if (isConnected) {
                              showLocalNoti(
                                fcmPayload(
                                  fireController.token.value,
                                  classesController.currentClass?.courseTitle ??
                                      " No title",
                                  classesController.currentClass?.courseCode ??
                                      "No code",
                                  classesController.currentClass?.location ??
                                      "No location",
                                ),
                              );
                            } else {
                              try {
                                sendPushMessage();
                                logger.infoLog("Notification Sent");
                              } catch (e) {
                                logger.debugLog(e);
                                logger.errorLog("An error Occurred", e);
                              }
                            }
                          },
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  String fcmPayload(
      String? token, String courseTitle, String courseCode, String location) {
    return jsonEncode({
      'token': fireController.token.value,
      'notification': {
        'title': "Class Time ⏰: $courseCode",
        'body': "Time for $courseTitle at $location",
      },
    });
  }

  Future<void> sendPushMessage() async {
    if (fireController.token.value == "") {
      Get.snackbar("Error", "Provide FCM token");
      logger.errorLog("FCM Error", "No FCM Token");
      return;
    }

    try {
      await http.post(
        Uri.parse(
            'https://jedwali-backend.vercel.app/api/v1/notifications/notify'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: fcmPayload(
          fireController.token.value,
          classesController.currentClass?.courseTitle ?? " No title",
          classesController.currentClass?.courseCode ?? "No code",
          classesController.currentClass?.location ?? "No location",
        ),
      );
      Get.snackbar("Success", "Notification Sent");
      logger.infoLog("Notification Sent successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
      logger.errorLog("Error Sendig notification", e);
      print(e);
    }
  }
}
