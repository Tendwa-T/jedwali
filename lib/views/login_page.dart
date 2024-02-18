import 'package:Jedwali/configs/constants.dart';
import 'package:Jedwali/controllers/login/login_controller.dart';
import 'package:Jedwali/widgets/custom_password_field.dart';
import 'package:Jedwali/widgets/custom_text.dart';
import 'package:Jedwali/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
    required TextEditingController usernameController,
    required TextEditingController passwordController,
    required this.loginController,
  })  : _usernameController = usernameController,
        _passwordController = passwordController;

  final TextEditingController _usernameController;
  final TextEditingController _passwordController;
  final LoginController loginController;

  @override
  Widget build(BuildContext context) {
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
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CustomText(label: "Forgot Password?"),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    print("Resetting password...");
                  },
                  child: const CustomText(
                    label: "Reset password",
                    labelColor: Colors.blue,
                  ),
                )
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
                    print("Cancel");
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
                  onPressed: () {
                    var uName = _usernameController.text;
                    var pWord = _passwordController.text;
                    if (loginController.validateLogin(uName, pWord) == true) {
                      _passwordController.clear();
                      _usernameController.clear();
                      toastification.show(
                          showProgressBar: false,
                          context: context,
                          type: ToastificationType.success,
                          title: const Text("Success!!"),
                          autoCloseDuration: const Duration(seconds: 2),
                          style: ToastificationStyle.flatColored,
                          description: Text("Welcome $uName"),
                          callbacks: ToastificationCallbacks(
                            onAutoCompleteCompleted: (value) {
                              Navigator.of(context).pushNamed('/');
                            },
                            onCloseButtonTap: (value) {
                              Navigator.of(context).pushNamed('/');
                            },
                            onDismissed: (value) {
                              Navigator.of(context).pushNamed('/');
                            },
                            onTap: (value) {
                              Navigator.of(context).pushNamed('/');
                            },
                          ));
                    } else {
                      loginController.showErrorModal(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: appWhite,
                      elevation: 4,
                      fixedSize: const Size(100, 30)),
                  child: const Text("Sign in"),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
