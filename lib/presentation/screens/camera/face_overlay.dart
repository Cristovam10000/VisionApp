import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';

// Overlay com foco circular
class FaceOverlay extends StatelessWidget {
  const FaceOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(child: CustomPaint(painter: FaceOverlayPainter())),
    );
  }
}



class FaceOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color.fromARGB(185, 51, 51, 51)
          ..style = PaintingStyle.fill;

    // Dimensões e posição do retângulo central
    final rectWidth = 282.0;
    final rectHeight = 452.0;
    final rectLeft = 47.0;
    final rectTop = 121.0;
    final borderRadius = 280.0;

    // Círculos para os botões
    final buttonRadius = 38.0;
    final ycapture = size.height - 62;
    final yflash = size.height - 62;
    final captureX = size.width / 1.715;
    final flashX = size.width / 3;

    // === CRIA O PATH COM FUROS ===
    final path =
        Path()
          ..fillType = PathFillType.evenOdd
          ..addRect(Rect.fromLTWH(0, 0, size.width, size.height)); // fundo todo

    // Furo retangular arredondado
    final rect = Rect.fromLTWH(rectLeft, rectTop, rectWidth, rectHeight);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    path.addRRect(rrect);

    // Furos circulares dos botões
    path.addOval(
      Rect.fromCircle(center: Offset(captureX, ycapture), radius: buttonRadius),
    );
    path.addOval(
      Rect.fromCircle(center: Offset(flashX, yflash), radius: buttonRadius),
    );

    // Desenha o path com furos
    canvas.drawPath(path, paint);

    // Borda do retângulo
    final borderPaint =
        Paint()
          ..color = ColorPalette.darkbutton
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0;
    canvas.drawRRect(rrect, borderPaint);

    // Bordas dos círculos dos botões (opcional)
    final circleBorderPaint =
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(captureX, ycapture),
      buttonRadius,
      circleBorderPaint,
    );
    canvas.drawCircle(Offset(flashX, yflash), buttonRadius, circleBorderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
