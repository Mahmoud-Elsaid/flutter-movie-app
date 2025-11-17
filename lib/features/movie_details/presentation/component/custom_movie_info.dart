import 'package:flutter/material.dart';

class CustomMovieInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final double? fontSize;
  const CustomMovieInfo({
    super.key,
    required this.text,
    this.iconColor,
    this.textColor,
    this.iconSize,
    this.fontSize,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? Colors.white, size: iconSize ?? 18),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: fontSize ?? 14,
          ),
        ),
      ],
    );
  }
}
