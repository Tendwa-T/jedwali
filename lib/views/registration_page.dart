import 'package:Jedwali/configs/constants.dart';
import 'package:Jedwali/controllers/login/login_controller.dart';
import 'package:Jedwali/login.dart';
import 'package:Jedwali/widgets/custom_password_field.dart';
import 'package:Jedwali/widgets/custom_text.dart';
import 'package:Jedwali/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({
    super.key,
  });

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confPassword = TextEditingController();
  final loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _firstNameController,
                    label: "First Name",
                    hint: "First name",
                    icon: Icons.tag_faces,
                  ),
                ),
                const SizedBox(
                  height: 20,
                  width: 20,
                ),
                Expanded(
                  child: CustomTextField(
                    controller: _lastNameController,
                    label: "Last Name",
                    hint: "Last name",
                    icon: Icons.tag_faces,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              controller: _userNameController,
              label: "Username",
              hint: "Enter your Username",
              icon: Icons.person,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              inputType: TextInputType.phone,
              controller: _phoneNumberController,
              label: "Phone number",
              hint: "Enter your phone number",
              icon: Icons.call,
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
            CustomPasswordField(
              controller: _confPassword,
              label: "Confirm Password",
              hint: "Re-enter your password",
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CustomText(label: "Already have an account?"),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    // loginKey.currentState?.switchTab(0);
                    DefaultTabController.of(context).animateTo(0);
                  },
                  child: CustomText(
                    label: "Log In",
                    labelColor: Theme.of(context).primaryColor,
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
                    debugPrint("Cancel");
                    _firstNameController.clear();
                    _confPassword.clear();
                    _userNameController.clear();
                    _lastNameController.clear();
                    _phoneNumberController.clear();
                    _passwordController.clear();
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
                    toastification.show(
                        showProgressBar: false,
                        context: context,
                        type: ToastificationType.success,
                        title: const Text("Success!!"),
                        style: ToastificationStyle.flatColored,
                        autoCloseDuration: const Duration(seconds: 1),
                        description: const Text("Account Created Successfully"),
                        callbacks: ToastificationCallbacks(
                          onAutoCompleteCompleted: (value) {
                            DefaultTabController.of(context).animateTo(0);
                          },
                          onCloseButtonTap: (value) {
                            DefaultTabController.of(context).animateTo(0);
                          },
                          onDismissed: (value) {
                            DefaultTabController.of(context).animateTo(0);
                          },
                          onTap: (value) {
                            DefaultTabController.of(context).animateTo(0);
                          },
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: appWhite,
                      elevation: 4,
                      fixedSize: const Size(100, 30)),
                  child: const Text("Sign Up"),
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
