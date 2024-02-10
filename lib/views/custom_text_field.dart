import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final Color labelColor;
  final double fontSize;

  const CustomTextField({
    super.key,
    required this.label,
    this.labelColor = Colors.grey,
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: labelColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
