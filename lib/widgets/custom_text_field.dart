// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final IconData? suffIcon;
  final String? hint;
  final double wid;
  final TextInputType? inputType;
  final List<TextInputFormatter>? formatter;

  const CustomTextField({
    super.key,
    required this.controller,
    this.icon,
    this.suffIcon,
    this.hint,
    required this.label,
    this.wid = double.infinity,
    this.inputType = TextInputType.text,
    this.formatter,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      keyboardType: inputType,
      controller: controller,
      obscureText: false,
      inputFormatters: formatter,
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
