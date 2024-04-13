// ignore_for_file: must_be_immutable

import 'package:jedwali/controllers/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPasswordField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final IconData? suffIcon;
  final bool isPassword;
  final String? hint;
  final double wid;
  final TextInputAction? inputAction;
  final VoidCallbackAction? action;
  final Color borderColor;

  CustomPasswordField({
    super.key,
    required this.controller,
    this.icon,
    this.suffIcon,
    this.isPassword = false,
    this.hint,
    required this.label,
    this.inputAction = TextInputAction.done,
    this.wid = double.infinity,
    this.action,
    this.borderColor = Colors.grey,
  });

  final TextEditingController controller;
  LoginController loginController = Get.find<LoginController>();
  bool get hideTextValue => loginController.hideText.value;

  @override
  Widget build(BuildContext context) {
    final error = loginController.activeError;
    return Obx(
      () => TextField(
        controller: controller,
        obscureText: hideTextValue,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            borderSide: BorderSide(
              color: error ? Colors.red : Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
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
          constraints: const BoxConstraints(
            maxHeight: 200,
            minWidth: 200,
          ),
        ),
      ),
    );
  }
}
