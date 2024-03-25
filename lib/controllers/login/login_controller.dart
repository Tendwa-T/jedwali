import 'dart:convert';

import 'package:Jedwali/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  Preferences prefs = Preferences();
  var username = "".obs;
  var password = "".obs;
  var hideText = true.obs;
  var rememberMeValue = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    updateRememberMeValue();
  }

  void updateRememberMeValue() async {
    rememberMeValue.value = await rememberMe;
  }

  void updateLoading(value){
    isLoading.value = value;
    update();
  }

  Future<bool> get rememberMe {
    return prefs.getBooleanValue("rememberMe");
  }

  Future<bool> userRegister(
      {required String fName,
      required String lName,
      required String admissionNumber,
      required String phoneNo,
      required String password,
      required String confPass}) async {
    if (password != confPass) {
      Get.snackbar("Error", "Passwords do not match");
      return false;
    } else {
      String apiUrl =
          "https://jedwali-backend.vercel.app/api/v1/users/user/create";
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
          Get.snackbar("Success", "Account Created. Log in to continue");
          return true;
        } else {
          throw Exception("Error ${response.statusCode}, ${response.body}");
        }
      } catch (e) {
        Get.snackbar("Error", e.toString());
        return false;
      }
    }
  }

  Future<bool> userLogin(String username, String password) async {
    updateLoading(true);
    String apiUrl =
        "https://jedwali-backend.vercel.app/api/v1/users/user/login";

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
        );
        final data = jsonDecode(response.body);
        await prefs
            .setValueString("name", data["userInfo"]["name"])
            .then((value) => Get.toNamed("/"));
        updateLoading(false);
        return true;
      } else {
        updateLoading(false);
        throw Exception("Error ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
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
                child: const Text("Ok"))
          ],
        );
      },
    );
  }
}
