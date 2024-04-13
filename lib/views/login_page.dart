import 'package:flutter/services.dart';
import 'package:jedwali/configs/constants.dart';
import 'package:jedwali/controllers/login/login_controller.dart';
import 'package:jedwali/utils/preferences.dart';
import 'package:jedwali/widgets/custom_password_field.dart';
import 'package:jedwali/widgets/custom_text.dart';
import 'package:jedwali/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class LoginPage extends StatelessWidget {
  LoginPage({
    super.key,
  });

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController loginController = Get.find<LoginController>();
  Preferences preferences = Preferences();
  @override
  Widget build(BuildContext context) {
    preferences.getValue("username").then((value) {
      _usernameController.text = value;
      preferences.getValue("password").then((value) {
        _passwordController.text = value;
      });
    });

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            CustomTextField(
              controller: _usernameController,
              label: "Admission Number",
              hint: "Enter Admission Number",
              icon: Icons.person,
              formatter: [AdmissionNumberFormatter()],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomPasswordField(
              controller: _passwordController,
              label: "Password",
              hint: "Enter your password",
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                FutureBuilder<bool>(
                  future: loginController.rememberMe,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error ${snapshot.error}");
                    } else {
                      return Obx(
                        () => Checkbox(
                          value: loginController.rememberMeValue.value,
                          onChanged: (bool? value) {
                            loginController.toggleRememberMe();
                            preferences.setBooleanValue(
                                "rememberMe", value! || false);
                          },
                        ),
                      );
                    }
                  },
                ),
                const CustomText(
                  label: "Remember Me",
                  fontSize: 17,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    debugPrint("Cancel");
                    _passwordController.clear();
                    _usernameController.clear();
                  },
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      elevation: 2,
                      fixedSize: const Size(100, 30),
                      side: const BorderSide()),
                  child: const Center(
                    child: Text("Cancel"),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    var uName = _usernameController.text;
                    var pWord = _passwordController.text;
                    loginController.updateLoading(true);
                    if ((await loginController.userLogin(uName, pWord)) ==
                        true) {
                      loginController.updateLoading(false);
                      if (await loginController.rememberMe == true) {
                        await preferences.setValueString("username", uName);
                        await preferences.setValueString("password", pWord);

                        loginController.updateLoading(false);
                      } else {
                        await preferences.setValueString("username", "");
                        await preferences.setValueString("password", "");
                        loginController.updateLoading(false);
                      }
                      _passwordController.clear();
                      _usernameController.clear();
                    }
                    loginController.updateLoading(false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: appWhite,
                    elevation: 4,
                    fixedSize: const Size(100, 30),
                  ),
                  child: const CustomText(
                    label: "Sign in",
                    labelColor: appWhite,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomText(label: "No Account?"),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    DefaultTabController.of(context).animateTo(1);
                  },
                  child: CustomText(
                    label: "Register",
                    labelColor: Theme.of(context).primaryColor,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => loginController.isLoading.value
                  ? _buildLoadingScreen()
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildLoadingScreen() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}

class AdmissionNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueText = newValue.text;
    if (newValueText == "") {
      return newValue;
    } else if (newValueText.length <= 2) {
      return newValue;
    } else if (newValueText.length == 3) {
      return newValueText.endsWith('-')
          ? newValue
          : TextEditingValue(
              text:
                  "${newValueText.substring(0, 2)}-${newValueText.substring(2)}",
            );
    } else if (newValueText.length <= 7) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
