// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:vision_app/presentation/widgets/state/state.dart';

Future<void> showAmbiguousFaceDialog(BuildContext context) async {

  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Ambiguidade detectada",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Não foi possível identificar com precisão o rosto. Por favor, use a função 'Buscar por CPF' para garantir uma verificação precisa.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: Button(text: "Ok", onPressed: () => Navigator.of(context).pop())
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
