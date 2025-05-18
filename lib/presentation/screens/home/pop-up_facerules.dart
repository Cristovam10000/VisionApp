// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:vision_app/presentation/screens/camera/face_camera_page.dart';
import 'package:vision_app/presentation/widgets/state/state.dart';


Widget infoText(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("• ", style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 25, 124, 238), fontWeight: FontWeight.bold)),
      Expanded(child: Text(text, style: TextStyle(fontSize: 16, color: Colors.black))),
    ],
  );
}

void mostrarPopUpRegrasFace({
  required BuildContext context,
  required Map<String, dynamic> perfil,
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
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              top: -15,
              right: -15,
              child: IconButton(
                icon: Icon(Icons.close, size: 28, color: Colors.black54),
                onPressed: () => Navigator.of(context).pop(),
                splashRadius: 22,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/teste_face.png', width: 70, height: 70),
            SizedBox(height: 20),
            infoText("Local bem iluminado"),
            infoText("Sem acessórios (boné, óculos, etc)"),
            infoText("Enquadramento na altura dos olhos (estilo 3x4)"),
            infoText("Olhe para a câmera"),
            infoText("Não envie foto tremida, embaçada ou escura"),
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
