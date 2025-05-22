import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';

class ImagePopup extends StatelessWidget {
  final String imageUrl;

  const ImagePopup({super.key, required this.imageUrl});

@override
Widget build(BuildContext context) {
  return Dialog(
    backgroundColor: Colors.transparent,
    child: Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 100), // ajuste a altura como quiser
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorPalette.branco,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.close, color: ColorPalette.dark),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}