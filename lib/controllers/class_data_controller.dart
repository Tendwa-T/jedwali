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
    Duration timeToNext = Duration(days: 31); // Initialize with a large value

    for (var lesson in lessons) {
      var lessonTime = lesson.time;
      int lessonDay = daysofWeek[lesson.day] ?? 0;

      List<String> timeparts = lessonTime.split(" - ");

      // Calculate the next date for the lesson
      String nextDate = "${nextDateOfDay(lessonDay)} ${timeparts[0]}";
      DateTime lessonStart = DateTime.parse(nextDate).toLocal();

      // Calculate the duration until the next lesson
      Duration duration = lessonStart.difference(now);

      // Update timeToNext if the current lesson is closer than the previously found lesson
      if (duration < timeToNext) {
        timeToNext = duration;
      }
    }

    // Update the observable value
    toNext.value = timeToNext;
    print(timeToNext);

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
