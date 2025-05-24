
import 'package:flutter/material.dart';

bool isFaceCentered(Rect boundingBox, Size screenSize) {
  final centerX = boundingBox.center.dx;
  final centerY = boundingBox.center.dy;

  // Retângulo de recorte usado no FaceOverlayPainter
  const rectLeft = 47.0;
  const rectTop = 121.0;
  const rectWidth = 296.0;
  const rectHeight = 452.0;

  final faceRectCenterX = rectLeft + rectWidth / 2;
  final faceRectCenterY = rectTop + rectHeight / 2;

  const toleranceX = 60.0; // pode ajustar conforme o necessário
  const toleranceY = 80.0;

  return (centerX - faceRectCenterX).abs() < toleranceX &&
         (centerY - faceRectCenterY).abs() < toleranceY;
}
