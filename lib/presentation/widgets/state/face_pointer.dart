// face_pointer.dart

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final bool isFaceInPosition;

  FacePainter(this.faces, this.imageSize, [this.isFaceInPosition = false]);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isFaceInPosition ? Colors.green : Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    for (final face in faces) {
      final rect = Rect.fromLTRB(
        face.boundingBox.left * scaleX,
        face.boundingBox.top * scaleY,
        face.boundingBox.right * scaleX,
        face.boundingBox.bottom * scaleY,
      );
      canvas.drawRect(rect, paint);

      final landmarkPaint = Paint()
        ..color = Colors.yellow
        ..style = PaintingStyle.fill
        ..strokeWidth = 3.0;
      
      for (final landmark in face.landmarks.values) {
        final position = landmark?.position;
        if (position != null) {
          canvas.drawCircle(
            Offset(
              position.x * scaleX,
              position.y * scaleY,
            ),
            2.0,
            landmarkPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant FacePainter old) => 
      old.faces != faces || old.isFaceInPosition != isFaceInPosition;
}
