// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:vision_app/presentation/screens/login/tela_login.dart';
import '../../widgets/state/state.dart';



void mostrarDialogoLogout(BuildContext context) {
  

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Botão de fechar alinhado à direita
            Stack(
              children: [
                Center(
                  child: const Text(
                    'Tem certeza que deseja\nsair do aplicativo ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  top: -15,
                  right: -15,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 28, color: Colors.black54),
                    onPressed: () => Navigator.of(context).pop(),
                    splashRadius: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            
            const SizedBox(height: 18),
            const Text(
              'Você precisará fazer login\nnovamente no próximo acesso.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(223, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: Button(text: "Sair do Aplicativo", backgroundColor: Colors.red, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,
                  color: Colors.white,) , 
                  onPressed: () {
                  Navigator.of(context).pop();
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