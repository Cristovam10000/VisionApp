// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/presentation/pages/camera/face_camera_page.dart';
import 'package:vision_app/presentation/widgets/state/infotextline.dart';
import 'package:vision_app/presentation/widgets/state/state.dart';

void mostrarPopUpRegrasFace({
  required BuildContext context,
  required Map<String, dynamic>? perfil,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Stack(
          children: [
            Center(
              child: Text(
                "Certifique-se de tirar \n uma boa foto",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              top: -16,
              right: -16,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 28,
                  color: ColorPalette.cinzaMedio,
                ),
                onPressed: () => Navigator.of(context).pop(),
                splashRadius: 22,
              ),
            ),
          ],
        ),
        backgroundColor: ColorPalette.branco,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/teste_face.png', width: 70, height: 70),
            SizedBox(height: 16),
            infoText("Local bem iluminado"),
            SizedBox(height: 5),
            infoText("Sem acessórios (boné, óculos, etc)"),
            SizedBox(height: 5),
            infoText("Enquadramento na altura dos olhos (estilo 3x4)"),
            SizedBox(height: 5),
            infoText("Olhe para a câmera"),
            SizedBox(height: 5),
            infoText("Não envie foto tremida, embaçada ou escura"),
            SizedBox(height: 5),
          ],
        ),
        actions: [
          Center(
            child: Button(
              text: "Entendido",
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FaceCameraPage(perfil: perfil),
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}