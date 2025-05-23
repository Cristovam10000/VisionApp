import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/presentation/screens/camera/face_camera_page.dart';
import 'package:vision_app/presentation/widgets/state/state.dart';

Future<void> showErrorFotoDialog(BuildContext context, Map<String, dynamic>? perfil) async {

  return showDialog(
    context: context,
    barrierColor: ColorPalette.dark,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: ColorPalette.branco,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Algo deu errado com a sua foto!",
                style:  Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Atente-se na visibilidade da face antes de enviar a foto.",
                style: TextStyle(
                  fontSize: 16,
                  color: ColorPalette.preto,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                child: Button(text: "Ok", 
                onPressed: () {
                
                    
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FaceCameraPage(perfil: perfil),
                    ),
                  );
                  
                    // true = sinal para limpar imagem

                  }

                
                )
              )
            ],
          ),
        ),
      );
    },
  );
}
