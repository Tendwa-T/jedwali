import 'dart:async';
import 'dart:convert';

import 'package:jedwali/configs/constants.dart';
import 'package:jedwali/main.dart';
import 'package:jedwali/models/class_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:jedwali/utils/preferences.dart';

class ClassesController extends GetxController {
  var lessons = <Classes>[].obs;
  var isLoadingClasses = false.obs;
  Classes? newClass;
  Rx<Duration> toNext = const Duration(days: 31).obs;
  Classes? currentClass;
  Rx<Duration> testDuration = const Duration(minutes: 1).obs;
  Timer? _timer;
  Preferences prefs = Preferences();
  late String studentID;

  Map<String, String> classData = {};
  var selectedCourseCode = "".obs;
  var selectedCourseName = "".obs;

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
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkAndUpdateTimeToNext();
    });
  }

  void updateSelectedCourse(String code) {
    selectedCourseCode.value = code;
    var matchingEntry = classData.entries.firstWhere(
      (element) => element.value == code,
    );
    selectedCourseName.value = matchingEntry.key;
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
    isLoadingClasses.value = true;
    studentID = await prefs.getValue("student_id");
    try {
      if (await InternetConnection().hasInternetAccess == false) {
        Get.snackbar(
          "Error",
          "No internet Access",
          icon: const Icon(
            Icons.wifi_off,
          ),
          backgroundColor: Colors.red.withOpacity(0.5),
        );
        isLoadingClasses.value = false;
        return;
      }
      final response = await http
          .get(Uri.parse("$baseAPI/api/v1/courses/student/$studentID"));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        lessons.value =
            jsonResponse.map((data) => Classes.fromJson(data)).toList();
        logger.infoLog("Fetched Classes: ${DateTime.now()}");
        isLoadingClasses.value = false;
        updateTimer();
      } else {
        isLoadingClasses.value = false;
        throw Exception("Failed to load classes ${response.body}");
      }
      for (var lesson in lessons.value) {
        classData[lesson.courseCode] = lesson.id ?? "";
      }
      selectedCourseCode.value = classData.values.first;
    } catch (e) {
      isLoadingClasses.value = false;

      Get.snackbar(
        "Error",
        e.toString(),
        icon: const Icon(
          Icons.cancel,
        ),
        backgroundColor: Colors.red.withOpacity(0.5),
      );
      return;
    }
  }

  Future<void> updateClass(Classes updatedClass) async {
    if (await InternetConnection().hasInternetAccess == false) {
      Get.snackbar(
        "Error",
        "No internet Access",
        icon: const Icon(
          Icons.wifi_off,
        ),
        backgroundColor: Colors.red.withOpacity(0.5),
      );
      return;
    }
    String apiUrl = '$baseAPI/api/v1/courses/course/${updatedClass.id}';

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
          "Class ${updatedClass.courseCode} updated",
          icon: const Icon(
            Icons.check,
          ),
          backgroundColor: Colors.green.withOpacity(0.5),
        );
        fetchClasses();
      } else {
        fetchClasses();
        throw Exception("${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        icon: const Icon(
          Icons.cancel,
        ),
        backgroundColor: Colors.red.withOpacity(0.5),
      );
      return;
    }
  }

  Future<void> deleteClass(id) async {
    if (await InternetConnection().hasInternetAccess == false) {
      Get.snackbar(
        "Error",
        "No internet Access",
        icon: const Icon(
          Icons.wifi_off,
        ),
        backgroundColor: Colors.red.withOpacity(0.5),
      );
      return;
    }
    String apiUrl = '$baseAPI/api/v1/courses/course/$id';
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: <String, String>{
        "Content-type": "application/json; charset=utf-8",
      },
    );
    try {
      if (response.statusCode == 200) {
        Get.snackbar(
          "Class Deleted",
          "Class has successfully been Deleted",
          icon: const Icon(
            Icons.check,
          ),
          backgroundColor: Colors.green.withOpacity(0.5),
        );
        fetchClasses();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        icon: const Icon(
          Icons.cancel,
        ),
        backgroundColor: Colors.red.withOpacity(0.5),
      );
      return;
    }
  }

  Future<void> createClass(Classes newClass) async {
    if (await InternetConnection().hasInternetAccess == false) {
      Get.snackbar(
        "Error",
        "No internet Access",
        icon: const Icon(
          Icons.wifi_off,
        ),
        backgroundColor: Colors.red.withOpacity(0.5),
      );
      return;
    }
    String apiUrl = '$baseAPI/api/v1/courses/create';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        "Content-type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(newClass.toJson()),
    );
    try {
      if (response.statusCode == 201) {
        fetchClasses();
        Get.snackbar(
          "Class Updated",
          "Class ${newClass.courseCode} Added",
          icon: const Icon(
            Icons.check,
          ),
          backgroundColor: Colors.green.withOpacity(0.5),
        );
      } else {
        throw Exception("${response.body} ");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        icon: const Icon(
          Icons.cancel,
        ),
        backgroundColor: Colors.red.withOpacity(0.5),
      );
      return;
    }
  }

  void updateTimer() {
    toNext.value = timeToNextClass();
  }

  Duration timeToNextClass() {
    DateTime now = DateTime.now().toLocal();
    Duration timeToNext =
        const Duration(days: 8); // Initialize with a large value

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
