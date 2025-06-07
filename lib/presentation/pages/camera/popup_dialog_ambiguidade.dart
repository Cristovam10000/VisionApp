// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/presentation/pages/buscacpf/tela_busca_cpf.dart';
import 'package:vision_app/presentation/widgets/state/state.dart';


Future<void> showAmbiguousFaceDialog(
  BuildContext context, {
  required String token,
}) async {
  return showDialog(
    context: context,
    barrierColor: ColorPalette.preto.withOpacity(0.6),
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: ColorPalette.branco,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    "Ambiguidade detectada",
                    style:  Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Não foi possível identificar com precisão o rosto. Por favor, use a função 'Buscar por CPF' para garantir uma verificação precisa.",
                    style: TextStyle(fontSize: 16, color: ColorPalette.preto, letterSpacing: 0),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Button(
                      text: "Buscar por CPF",
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaBuscaCpf(
                              token: token,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Ícone de fechar no canto superior direito
            Positioned(
              top: 15,
              right: 15,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.close,
                  size: 24,
                  color: ColorPalette.cinzaMedio,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
