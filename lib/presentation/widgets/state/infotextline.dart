import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';

Widget infoTextLine(String label, String value) {
  return RichText(
    text: TextSpan(
      style: const TextStyle(fontSize: 18, color: ColorPalette.branco),
      children: [
        TextSpan(
          text: label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: value),
      ],
    ),
  );
}

Widget infoText(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "• ",
        style: TextStyle(
          height: 0.35,
          fontSize: 50,
          color: ColorPalette.lightbutton,
          fontWeight: FontWeight.bold,
        ),
      ),
      Expanded(
        child: Text(text, style: TextStyle(fontSize: 16, color: ColorPalette.preto, fontWeight: FontWeight.w400)),
      ),
    ],
  );
}
