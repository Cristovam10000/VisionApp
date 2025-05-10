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

    // Desenha as faces detectadas
    for (final face in faces) {
      final rect = Rect.fromLTRB(
        face.boundingBox.left * scaleX,
        face.boundingBox.top * scaleY,
        face.boundingBox.right * scaleX,
        face.boundingBox.bottom * scaleY,
      );
      canvas.drawRect(rect, paint);
      
      // Desenha pontos de referência facial se disponíveis
      if (face.landmarks.isNotEmpty) {
        final landmarkPaint = Paint()
          ..color = Colors.yellow
          ..style = PaintingStyle.fill
          ..strokeWidth = 3.0;
        
        for (final landmark in face.landmarks.values) {
          final position = landmark;
          canvas.drawCircle(
            Offset(
              (position?.position.x ?? 0) * scaleX, // Usa 0 como valor padrão se position for null
              (position?.position.y ?? 0) * scaleY, // Usa 0 como valor padrão se position for null
            ),
            2.0,
            landmarkPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant FacePainter old) => old.faces != faces;
}