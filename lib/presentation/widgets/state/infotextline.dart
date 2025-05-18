import 'package:flutter/material.dart';

Widget infoTextLine(String label, String value) {
  return RichText(
    text: TextSpan(
      style: const TextStyle(fontSize: 18, color: Colors.white),
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
          fontSize: 16,
          color: Color.fromARGB(255, 25, 124, 238),
          fontWeight: FontWeight.bold,
        ),
      ),
      Expanded(
        child: Text(text, style: TextStyle(fontSize: 16, color: Colors.black)),
      ),
    ],
  );
}
