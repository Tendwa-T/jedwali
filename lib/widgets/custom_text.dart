import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String label;
  final Color? labelColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomText(
      {super.key,
      required this.label,
      this.labelColor = Colors.grey,
      this.fontSize = 15,
      this.fontWeight = FontWeight.w500});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: labelColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
