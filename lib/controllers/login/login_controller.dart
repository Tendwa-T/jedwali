import 'dart:convert';

import 'package:jedwali/controllers/assignment_controller.dart';
import 'package:jedwali/utils/preferences.dart';
import 'package:jedwali/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:jedwali/views/dashboard_page.dart';

class LoginController extends GetxController {
  Preferences prefs = Preferences();
  AssignmentController assignmentController = Get.put(AssignmentController());
  var username = "".obs;
  var password = "".obs;
  var fName = "".obs;
  var lName = "".obs;
  var phoneNo = "".obs;
  var email = "".obs;
  var hideText = true.obs;
  var rememberMeValue = false.obs;
  var isLoading = false.obs;
  var errorOccured = {
    "format-error": false,
    "match-error": false,
  }.obs;
  var passwordsMatch = true.obs;
  var passwordInvalid = false.obs;
  var passwordEmpty = false.obs;
  var errorMessage = "".obs;

  final passwordRegEx =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  @override
  void onInit() {
    super.onInit();
    updateRememberMeValue();
  }

  void updateRememberMeValue() async {
    rememberMeValue.value = await rememberMe;
  }

  void updateLoading(value) {
    isLoading.value = value;
  }

  // Validate Functions

  Future<bool> validatePasswordFormat(
    value,
  ) async {
    RegExp passRegEx =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    String passValue = value ?? "";

    if (passValue.isEmpty) {
      passwordEmpty.value = true;
      errorOccured['format-error'] = true;
      errorMessage.value = ("Password is required");
      return false;
    } else if (passValue.length < 6) {
      passwordInvalid.value = true;
      errorOccured['format-error'] = true;
      errorMessage.value = ("Password Must be more than 5 characters");
      return false;
    } else if (!passRegEx.hasMatch(passValue)) {
      passwordInvalid.value = true;
      errorOccured['format-error'] = true;
      errorMessage.value =
          ("Password should contain uppercase, lowercase, digit and special Characters");
      return false;
    }
    errorOccured['format-error'] = false;

    return true;
  }

  Future<bool> validateConfPass(a, b) async {
    if (a != b) {
      errorOccured['match-error'] = true;
      errorMessage.value = "Passwords do no match";
      return false;
    }
    errorOccured['match-error'] = false;
    return true;
  }

  Future<bool> get rememberMe {
    return prefs.getBooleanValue("rememberMe");
  }

  bool get activeError {
    if (errorOccured['match-error'] == true ||
        errorOccured['format-error'] == true) {
      return true;
    }
    return false;
  }

  Future<bool> userRegister({
    required String fName,
    required String lName,
    required String admissionNumber,
    required String phoneNo,
    required String password,
    required String confPass,
  }) async {
    if (await validatePasswordFormat(password) == false ||
        await validateConfPass(password, confPass) == false) {
      Get.snackbar(
        "Error",
        "Check Your passwords",
        icon: const Icon(
          Icons.wifi_off,
        ),
        backgroundColor: Colors.red.withOpacity(0.5),
      );
      return false;
    } else {
      if (await InternetConnection().hasInternetAccess == false) {
        Get.snackbar(
          "Error",
          "No internet Access",
          icon: const Icon(
            Icons.wifi_off,
          ),
          backgroundColor: Colors.red.withOpacity(0.5),
        );
        return false;
      }
      String apiUrl = "$baseAPI/api/v1/users/user/create";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "firstName": fName,
          "secondName": lName,
          "admissionNumber": admissionNumber,
          "phoneNumber": phoneNo,
          "password": password
        }),
      );
      try {
        if (response.statusCode == 201) {
          Get.snackbar(
            "Success",
            "Account Created. Log in to continue",
            icon: const Icon(
              Icons.check,
            ),
            backgroundColor: Colors.green.withOpacity(0.5),
          );
          return true;
        } else {
          throw Exception("Error ${response.statusCode}, ${response.body}");
        }
      } catch (e) {
        Get.snackbar(
          "Error",
          e.toString(),
          icon: const Icon(
            Icons.wifi_off,
          ),
          backgroundColor: Colors.red.withOpacity(0.5),
        );
        return false;
      }
    }
  }

  Future<void> userLogout() async {
    classesController.lessons.clear();
    prefsController.name.value = "";
    prefsController.studentID.value = "";
    assignmentController.assignments.clear();
    classesController.classData.clear();
    assignmentController.upcomingAssignments.clear();
    assignmentController.overdueAssignments.clear();
    assignmentController.submittedAssignments.clear();
    await prefs.clearAll().then((value) => Get.offAllNamed("/login"));
  }

  Future<bool> userLogin(String username, String password) async {
    if (await InternetConnection().hasInternetAccess == false) {
      Get.snackbar(
        "Error",
        "No internet Access",
        icon: const Icon(
          Icons.wifi_off,
        ),
        backgroundColor: Colors.red.withOpacity(0.5),
      );
      return false;
    }
    String apiUrl = "$baseAPI/api/v1/users/user/login";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"admissionNumber": username, "password": password}),
    );
    try {
      if (response.statusCode == 200) {
        Get.snackbar(
          "Login Successful",
          "Welcome $username",
          icon: const Icon(
            Icons.check,
          ),
          backgroundColor: Colors.green.withOpacity(0.5),
        );
        final data = jsonDecode(response.body);
        await prefs.setValueString("name", data["userInfo"]["name"]).then(
              (value) => prefs
                  .setValueString("student_id", data["userInfo"]["id"])
                  .then(
                    (value) => prefs
                        .setBooleanValue("isAdmin", data["userInfo"]["isAdmin"])
                        .then((value) {
                      prefsController.loadDetails();
                    }),
                  ),
            );
        updateLoading(false);
        Get.toNamed('/');
        return true;
      } else {
        updateLoading(false);
        throw Exception("Error ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        icon: const Icon(
          Icons.wifi_off,
        ),
        backgroundColor: Colors.red.withOpacity(0.5),
      );
      updateLoading(false);
      return false;
    }
  }

  updateValues(uName, pWord) {
    username.value = uName;
    password.value = pWord;
  }

  toggleHideText() {
    hideText.value = !hideText.value;
  }

  Future<void> toggleRememberMe() async {
    bool currentValue = await rememberMe;
    await prefs.setBooleanValue("rememberMe", !currentValue);
    updateRememberMeValue();
  }

  void showErrorModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Wrong username or password. Please try again'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            )
          ],
        );
      },
    );
  }
}
