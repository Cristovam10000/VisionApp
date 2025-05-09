import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';  // traz Face

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;  // importado de dart:ui via flutter/material

  FacePainter(this.faces, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final scaleX = size.width / imageSize.height;
    final scaleY = size.height / imageSize.width;

    for (final face in faces) {
      final rect = Rect.fromLTRB(
        face.boundingBox.left * scaleX,
        face.boundingBox.top * scaleY,
        face.boundingBox.right * scaleX,
        face.boundingBox.bottom * scaleY,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FacePainter old) => old.faces != faces;
}
