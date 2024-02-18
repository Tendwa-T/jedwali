// ignore_for_file: must_be_immutable

import 'package:Jedwali/controllers/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPasswordField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final IconData? suffIcon;
  final bool isPassword;
  final String? hint;
  final double wid;

  CustomPasswordField({
    super.key,
    required this.controller,
    this.icon,
    this.suffIcon,
    this.isPassword = false,
    this.hint,
    required this.label,
    this.wid = double.infinity,
  });

  final TextEditingController controller;
  LoginController loginController = Get.put(LoginController());
  bool get hideTextValue => loginController.hideText.value;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextField(
        controller: controller,
        obscureText: hideTextValue,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: () {
                    //toggle visibility of the icon
                    loginController.toggleHideText();
                  },
                  child: Obx(() => loginController.hideText.value
                      ? GestureDetector(
                          onTap: () {
                            //toggle visibility of the icon
                            loginController.toggleHideText();
                          },
                          child: const Icon(Icons.visibility_off),
                        )
                      : GestureDetector(
                          onTap: () {
                            loginController.toggleHideText();
                          },
                          child: const Icon(Icons.visibility),
                        )),
                )
              : const SizedBox(
                  height: 10,
                  width: 10,
                ),
          label: Text(label),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          constraints: const BoxConstraints(
            maxHeight: 200,
            minWidth: 200,
          ),
        ),
      ),
    );
  }
}
