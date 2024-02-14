import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final IconData? suffIcon;
  bool hideText;
  final bool isPassword;
  final String? hint;
  final double wid;

  CustomTextField({
    super.key,
    required this.controller,
    this.icon,
    this.suffIcon,
    this.hideText = false,
    this.isPassword = false,
    this.hint,
    required this.label,
    this.wid = double.infinity,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: () {
                  //toggle visibility of the icon
                  hideText = !hideText;
                },
                child: hideText
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              )
            : Container(
                height: 10,
                width: 10,
              ),
        label: Text(label),
        hintText: hint,
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
    );
  }
}
