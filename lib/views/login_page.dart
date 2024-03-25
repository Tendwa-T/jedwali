import 'package:Jedwali/configs/constants.dart';
import 'package:Jedwali/controllers/login/login_controller.dart';
import 'package:Jedwali/utils/preferences.dart';
import 'package:Jedwali/widgets/custom_password_field.dart';
import 'package:Jedwali/widgets/custom_text.dart';
import 'package:Jedwali/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
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
    final RxBool isLoading = false.obs;
    preferences.getValue("username").then((value) {
      _usernameController.text = value;
    });
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            CustomTextField(
              controller: _usernameController,
              label: "Username",
              hint: "Enter username",
              icon: Icons.person,
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
                        loginController.updateLoading(false);
                      } else {
                        await preferences.setValueString("username", "");
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
            Obx(() =>
            loginController.isLoading.value ? _buildLoadingScreen() : SizedBox.shrink()),
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
