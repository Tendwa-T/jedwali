import 'dart:async';
import 'dart:convert';

import 'package:jedwali/configs/constants.dart';
import 'package:jedwali/main.dart';
import 'package:jedwali/models/assignment_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:jedwali/utils/preferences.dart';

class AssignmentController extends GetxController {
  final _formKey = GlobalKey<FormState>();
  var assignments = <Assignment>[].obs;
  var submittedAssignments = <Assignment>[].obs;
  var overdueAssignments = <Assignment>[].obs;
  var upcomingAssignments = <Assignment>[].obs;
  var isLoadingAssignments = false.obs;
  DateTime now = DateTime.now();
  late DateTime tomorrow;
  late DateTime inAWeek;
  Assignment? newAssignment;
  Preferences prefs = Preferences();

  void submitForm(Assignment assignment) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      createAssignment(assignment);
    }
  }

  Future<void> fetchAssignments() async {
    isLoadingAssignments.value = true;
    assignments.clear();
    submittedAssignments.clear();
    overdueAssignments.clear();
    upcomingAssignments.clear();

    String studentID = await prefs.getValue("student_id");
    try {
      if (await InternetConnection().hasInternetAccess == false) {
        Get.snackbar(
          "Error",
          "No Internet Access",
          icon: const Icon(Icons.wifi_off),
          backgroundColor: Colors.red.withOpacity(0.5),
        );
        isLoadingAssignments.value = false;
        return;
      }
      final response = await http
          .get(Uri.parse("$baseAPI/api/v1/assignments/student/$studentID"));
      if (response.statusCode == 200) {
        List jsonResponse = jsonDecode(response.body);

        assignments.value =
            jsonResponse.map((data) => Assignment.fromJson(data)).toList();
        assignments.sort((a, b) {
          return DateTime.parse(a.dueDate).compareTo(DateTime.parse(b.dueDate));
        });
        sortAssignmentsByCategory();
        logger.infoLog("Fetched Assignments: ${DateTime.now()}");
        isLoadingAssignments.value = false;
      } else {
        isLoadingAssignments.value = false;

        throw Exception(response.body);
      }
    } catch (e) {
      isLoadingAssignments.value = false;
      logger.errorLog("FetchAssignment", e);
      Get.snackbar(
        "Error",
        "Could not fetch Assignments",
        icon: const Icon(
          Icons.cancel,
        ),
        backgroundColor: Colors.red.withOpacity(0.5),
      );
      return;
    }
  }

  Future<void> deleteAssignment(id) async {
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
    String apiUrl = '$baseAPI/api/v1/assignments/assignment/$id';
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: <String, String>{
        "Content-type": "application/json; charset=utf-8",
      },
    );
    try {
      if (response.statusCode == 200) {
        Get.snackbar(
          "Assignment Deleted",
          "Assignment has successfully been Deleted",
          icon: const Icon(
            Icons.check,
          ),
          backgroundColor: Colors.green.withOpacity(0.5),
        );
        fetchAssignments();
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

  Future<void> sortAssignmentsByCategory() async {
    tomorrow = DateTime(now.year, now.month, now.day + 1);
    inAWeek = DateTime(now.year, now.month, now.day + 7);
    upcomingAssignments.clear();
    submittedAssignments.clear();
    overdueAssignments.clear();

    for (var assignment in assignments) {
      if (assignment.submitted == false) {
        if (DateTime.parse(assignment.dueDate).isBefore(now)) {
          overdueAssignments.add(assignment);
          continue;
        }
        upcomingAssignments.add(assignment);
        continue;
      } else {
        submittedAssignments.add(assignment);
        continue;
      }
    }
  }

  Future<void> createAssignment(Assignment newAssignment) async {
    isLoadingAssignments.value = true;
    try {
      if (await InternetConnection().hasInternetAccess == false) {
        Get.snackbar(
          "Error",
          "No Internet Access",
          icon: const Icon(Icons.wifi_off),
          backgroundColor: Colors.red.withOpacity(0.5),
        );
        isLoadingAssignments.value = false;
        return;
      }
      final response = await http.post(
        Uri.parse("$baseAPI/api/v1/assignments/create/"),
        headers: <String, String>{
          "Content-type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(newAssignment.toJson()),
      );
      if (response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "Assignment ${newAssignment.title} created successfully",
          icon: const Icon(
            Icons.check,
          ),
          messageText: RichText(
              text: TextSpan(
                  text: "Assignment ",
                  style: const TextStyle().copyWith(color: Colors.black),
                  children: [
                TextSpan(
                    text: newAssignment.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                TextSpan(
                  text: ' created Successfully',
                  style: const TextStyle().copyWith(color: Colors.black),
                )
              ])),
          backgroundColor: Colors.green.withOpacity(0.5),
        );
        await fetchAssignments();
        isLoadingAssignments.value = false;
      } else {
        isLoadingAssignments.value = false;
        throw response.body;
      }
    } catch (e) {
      isLoadingAssignments.value = false;
      logger.infoLog(e);
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

  Future<void> updateAssignment(Assignment updatedAssignment) async {
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

    final response = await http.put(
      Uri.parse(
          "$baseAPI/api/v1/assignments/assignment/${updatedAssignment.id}"),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedAssignment.toJson()),
    );
    try {
      if (response.statusCode == 200) {
        Get.snackbar(
          "Assignment Updated",
          "Assignment ${updatedAssignment.title} updated",
          icon: const Icon(
            Icons.check,
          ),
          backgroundColor: Colors.green.withOpacity(0.5),
        );
        fetchAssignments();
      } else {
        fetchAssignments();
        logger.infoLog(response.body);
        throw (response.body);
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

  bool areDateEqual(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
