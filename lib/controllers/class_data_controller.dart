import 'dart:async';
import 'dart:convert';

import 'package:Jedwali/models/class_model.dart';
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
  Classes? currentClass;
  Rx<Duration> testDuration = Duration(minutes: 1).obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkAndUpdateTimeToNext();
    });
  }

  void checkAndUpdateTimeToNext() {
    Duration nextClassTime = timeToNextClass();

    if (nextClassTime < toNext.value) {
      toNext.value = nextClassTime;
    }
  }

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

  Future<void> deleteClass(Classes delClass) async {
    String apiUrl =
        'https://jedwali-backend.vercel.app/api/v1/lessons/lessons/${delClass.id}';
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: <String, String>{
        "Content-type": "application/json; charset=utf-8",
      },
      body: jsonEncode(delClass.toJson()),
    );
    try {
      if (response.statusCode == 200) {
        Get.snackbar(
          "Class Deleted",
          "Class has successfully been Deleted",
        );
        fetchClasses();
      } else {
        throw Exception("${response.body} ");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> createClass(Classes newClass) async {
    String apiUrl = 'https://jedwali-backend.vercel.app/api/v1/lessons/create';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        "Content-type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(newClass.toJson()),
    );
    try {
      if (response.statusCode == 201) {
        Get.snackbar(
          "Class Updated",
          "Class ${newClass.course_code} Added",
        );
        fetchClasses();
      } else {
        throw Exception("${response.body} ");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void updateTimer() {
    toNext.value = timeToNextClass();
  }

  Duration timeToNextClass() {
    DateTime now = DateTime.now().toLocal();
    Duration timeToNext =
        const Duration(days: 31); // Initialize with a large value

    for (var lesson in lessons) {
      var lessonTime = lesson.time;
      int lessonDay = daysofWeek[lesson.day]!;
      List<String> timeparts = lessonTime.split(" - ");

      if (lessonDay == now.weekday) {
        String lessonStartTime =
            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${timeparts[0]}";
        DateTime lessonStart = DateTime.parse(lessonStartTime).toLocal();
        if (lessonStart.isAfter(now)) {
          Duration duration = lessonStart.difference(now);

          if (duration < timeToNext) {
            timeToNext = duration;
            currentClass = lesson;
          }
        }
      } else {
        String lessonStartTime = "${nextDateOfDay(lessonDay)} ${timeparts[0]}";
        DateTime lessonStart = DateTime.parse(lessonStartTime).toLocal();
        Duration duration = lessonStart.difference(now);

        if (duration < timeToNext) {
          timeToNext = duration;
          currentClass = lesson;
        }
      }
    }

    // Update the observable value
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
