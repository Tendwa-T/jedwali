// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTextController extends StatelessWidget {
  final IconData? icon;
  final bool hideText;
  bool isPassword;
  final String? hint;
  final TextEditingController controller;

  CustomTextController({
    super.key,
    required this.controller,
    this.icon,
    this.hideText = false,
    this.hint,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: GestureDetector(
          onTap: () {
            isPassword = !isPassword;
          },
          child: isPassword
              ? const Icon(Icons.visibility_rounded)
              : const Icon(Icons.visibility_off_rounded),
        ),
      ),
    );
  }
}
