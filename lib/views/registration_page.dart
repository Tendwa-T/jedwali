import 'dart:ui' as ui;

import 'package:jedwali/configs/constants.dart';
import 'package:jedwali/controllers/login/login_controller.dart';
import 'package:jedwali/widgets/custom_password_field.dart';
import 'package:jedwali/widgets/custom_text.dart';
import 'package:jedwali/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    final RxBool isLoading = false.obs;
    clearForm();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            GetBuilder<LoginController>(
              builder: (loginController) => Form(
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
                    Obx(
                      () => CustomPasswordField(
                        controller: _passwordController,
                        label: "Password",
                        hint: "Enter your password",
                        icon: Icons.lock,
                        isPassword: true,
                        borderColor: loginController.errorMessage.isNotEmpty
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        child: Text(
                          loginController.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
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
                    Obx(() {
                      if (loginController.activeError == true) {
                        return Text(
                          loginController.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
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
                            clearForm();
                          },
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              elevation: 2,
                              fixedSize: const ui.Size(100, 30),
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
                            isLoading.value = true;
                            var fName = _firstNameController.text;
                            var confPass = _confPassword.text;
                            var admissionNumber = _userNameController.text;
                            var lName = _lastNameController.text;
                            var phoneNo = _phoneNumberController.text;
                            var password = _passwordController.text;
                            if (await loginController.userRegister(
                                  fName: fName,
                                  lName: lName,
                                  admissionNumber: admissionNumber,
                                  phoneNo: phoneNo,
                                  password: password,
                                  confPass: confPass,
                                ) ==
                                true) {
                              DefaultTabController.of(context).animateTo(0);
                            }
                            isLoading.value = false;
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: appWhite,
                              elevation: 4,
                              fixedSize: const ui.Size(100, 30)),
                          child: const Text("Sign Up"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Obx(() => isLoading.value
                ? _buildLoadingScreen()
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  void clearForm() {
    _firstNameController.clear();
    _confPassword.clear();
    _userNameController.clear();
    _lastNameController.clear();
    _phoneNumberController.clear();
    _passwordController.clear();
    loginController.errorMessage.value = "";
  }
}

Widget _buildLoadingScreen() {
  return BackdropFilter(
    filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    child: const Center(
      child: CircularProgressIndicator(),
    ),
  );
}
