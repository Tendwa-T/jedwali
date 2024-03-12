import 'package:Jedwali/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  Preferences prefs = Preferences();
  var username = "".obs;
  var password = "".obs;
  var hideText = true.obs;
  var rememberMeValue = false.obs;

  @override
  void onInit() {
    super.onInit();
    updateRememberMeValue();
  }

  void updateRememberMeValue() async {
    rememberMeValue.value = await rememberMe;
  }

  Future<bool> get rememberMe {
    return prefs.getBooleanValue("rememberMe");
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

  validateLogin(uName, pword) {
    if (uName == 'Admin') {
      if (pword == 'admin') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
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
