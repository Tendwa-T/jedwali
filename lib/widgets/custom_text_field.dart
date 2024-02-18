// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final IconData? suffIcon;
  final String? hint;
  final double wid;

  const CustomTextField({
    super.key,
    required this.controller,
    this.icon,
    this.suffIcon,
    this.hint,
    required this.label,
    this.wid = double.infinity,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: false,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
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
