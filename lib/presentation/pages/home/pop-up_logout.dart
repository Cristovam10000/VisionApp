// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/presentation/pages/login/tela_login.dart';
import '../../widgets/state/state.dart';



void mostrarDialogoLogout(BuildContext context) {
  

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: ColorPalette.branco,
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Botão de fechar alinhado à direita
            Stack(
              children: [
                Center(
                  child: Text(
                    'Tem certeza que deseja\nsair do aplicativo ?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Positioned(
                  top: -15,
                  right: -17,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 28, color: ColorPalette.cinzaMedio),
                    onPressed: () => Navigator.of(context).pop(),
                    splashRadius: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            
            const SizedBox(height: 18),
            const Text(
              'Você precisará fazer login novamente no próximo acesso.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: ColorPalette.preto,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              child: Button(text: "Sair da sua Conta", backgroundColor: ColorPalette.vermelhoPaleta, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,
                  color: ColorPalette.branco,) , 
                  onPressed: () {
                  Navigator.of(context).pop();
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaLogin()
                    ),
                  );
                },)
            ),
          ],
        ),
      ),
    ),
  );
}