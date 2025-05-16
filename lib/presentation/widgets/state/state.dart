import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final TextStyle? textStyle;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        minimumSize: Size(width ?? 149, height ?? 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: textStyle ??
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
      ),
    );
  }
}


// Botão com ícone e texto
class HomeButton extends StatelessWidget {
  final IconData? icone;
  final String? assetImagePath;
  final String texto;
  final VoidCallback onPressed;

  const HomeButton({
    super.key,
    this.icone,
    this.assetImagePath,
    required this.texto,
    required this.onPressed,
  });

  @override
    Widget build(BuildContext context) {
      Widget? visual;
      if (assetImagePath != null) {
        visual = Image.asset(assetImagePath!, width: 70, height: 70);
      } else if (icone != null) {
        visual = Icon(icone, size: 50);
      }

      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(273, 150),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(16),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (visual != null) visual,
            if (visual != null) const SizedBox(height: 20),
            Text(texto, style: const TextStyle(fontSize: 14)),
          ],
        ),
      );
    }
}
