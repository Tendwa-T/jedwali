import 'dart:async';
import 'dart:convert';

import 'package:Jedwali/models/class_model.dart';
import 'package:Jedwali/widgets/custom_text.dart';
import 'package:Jedwali/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

TextEditingController _courseCodeCtrl = TextEditingController();
TextEditingController _courseTitleCtrl = TextEditingController();

class ClassesController extends GetxController {
  var lessons = <Classes>[].obs;
  Classes? newClass;
  Rx<Duration> toNext = Duration(days: 31).obs;

  final Map<String, int> daysofWeek = {
    "Monday": 1,
    "Tuesday": 2,
    "Wednesday": 3,
    "Thursday": 4,
    "Friday": 5,
  };
  Future<void> fetchClasses() async {
    lessons.value = [];
    try {
      final response = await http
          .get(Uri.parse('https://jedwali-backend.vercel.app/api/v1/lessons/'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        lessons.value =
            jsonResponse.map((data) => Classes.fromJson(data)).toList();
        Get.snackbar("Success", "Classes fetched");
        updateTimer();
      } else {
        throw Exception("Failed to load classes");
      }
    } catch (e) {
      Get.snackbar("Error", "Could not fetch classes");
    }
  }

  Future<void> updateCLass(Classes updatedClass) async {
    String apiUrl =
        'https://jedwali-backend.vercel.app/api/v1/lessons/lessons/${updatedClass.id}';

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedClass.toJson()),
    );
    try {
      if (response.statusCode == 200) {
        Get.snackbar(
          "Class Updated",
          "Class ${updatedClass.course_code} updated",
        );
        fetchClasses();
      } else {
        fetchClasses();
        throw Exception("${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      fetchClasses();
    }
  }

  void updateTimer() {
    toNext.value = timeToNextClass();
  }

  Duration timeToNextClass() {
    DateTime now = DateTime.now().toLocal();
    int currentDayOfWeek = now.weekday;
    Duration timeToNext = Duration(days: 31);

    for (var lesson in lessons) {
      var lessonTime = lesson.time;
      int lessonDay = daysofWeek[lesson.day] ?? 0;

      List<String> timeparts = lessonTime.split(" - ");
      String nextDate = "${nextDateOfDay(lessonDay)} ${timeparts[0]}";

      DateTime lessonStart = DateTime.parse(nextDate).toLocal();

      if (lessonDay >= currentDayOfWeek) {
        if (lessonDay == currentDayOfWeek && lessonStart.isAfter(now)) {
          Duration duration = lessonStart.difference(now);
          if (duration < timeToNext) {
            timeToNext = duration;
          }
        } else {
          DateTime nextLessonStart =
              DateTime.parse("${nextDateOfDay(lessonDay)} ${timeparts[0]}")
                  .toLocal();
          Duration duration = nextLessonStart.difference(now);
          if (duration < timeToNext) {
            timeToNext = duration;
          }
        }
      } else {
        DateTime nextLessonStart =
            DateTime.parse("${nextDateOfDay(lessonDay)} ${timeparts[0]}");
        Duration duration = nextLessonStart.difference(now);
        if (duration < timeToNext) {
          timeToNext = duration;
        }
      }
    }
    toNext.value = timeToNext;
    return timeToNext;
  }

  String nextDateOfDay(int day) {
    DateTime now = DateTime.now().toLocal();
    int currentDayofWeek = now.weekday;
    int daysUntilNext = ((day + 7) - currentDayofWeek) % 7;

    if (daysUntilNext == 0) {
      daysUntilNext = 7;
    }

    DateTime nextDate = now.add(Duration(days: daysUntilNext));
    String test = nextDate.toString().split(" ")[0];
    return test;
  }
}
