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
    final rectWidth = 296.0;
    final rectHeight = 452.0;
    final rectLeft = 47.0;
    final rectTop = 121.0;
    final borderRadius = 280.0;

    // Círculos para os botões
    // Círculos para os botões
    final buttonRadiusCapture = 39.0;
    final buttonRadiusFlash = 24.1;
    final ycapture = size.height - 80;
    final yflash = size.height - 80;

    // TROCADOS
    final flashX = size.width / 1.555;
    final captureX = size.width / 2.53;

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
      Rect.fromCircle(
        center: Offset(captureX, ycapture),
        radius: buttonRadiusCapture,
      ),
    );
    path.addOval(
      Rect.fromCircle(
        center: Offset(flashX, yflash),
        radius: buttonRadiusFlash,
      ),
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
      buttonRadiusCapture,
      circleBorderPaint,
    );
    canvas.drawCircle(
      Offset(flashX, yflash),
      buttonRadiusFlash,
      circleBorderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
