import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/presentation/widgets/state/state.dart';

Future<void> showNadaConstaDialog(BuildContext context) async {
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
                "Nada consta!",
                style:  Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Nada consta na ficha criminal desse cidadão.",
                style: TextStyle(
                  fontSize: 16,
                  color: ColorPalette.preto,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                child: Button(text: "Ok", onPressed: () => Navigator.of(context).pop())
              )
            ],
          ),
        ),
      );
    },
  );
}
