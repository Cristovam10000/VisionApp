import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';

/// Verifica se o rosto detectado está centralizado na tela
bool isFaceCentered(Rect boundingBox, Size screenSize, {double tolerance = 0.25}) {
  final faceCenterX = boundingBox.left + boundingBox.width / 2;
  final faceCenterY = boundingBox.top + boundingBox.height / 2;

  final screenCenterX = screenSize.width / 2;
  final screenCenterY = screenSize.height / 2;

  final xTolerance = screenSize.width * tolerance;
  final yTolerance = screenSize.height * tolerance;

  return (faceCenterX - screenCenterX).abs() <= xTolerance &&
         (faceCenterY - screenCenterY).abs() <= yTolerance;
}
