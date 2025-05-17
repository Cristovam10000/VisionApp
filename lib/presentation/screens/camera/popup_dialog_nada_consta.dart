import 'package:flutter/material.dart';
import 'package:vision_app/presentation/widgets/state/state.dart';

Future<void> showNadaConstaDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierColor: const Color(0xFF12161c),
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
                "Nada consta!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Nada consta na ficha criminal desse cidadão.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Button(text: "Ok", onPressed: () => Navigator.of(context).pop())
              )
            ],
          ),
        ),
      );
    },
  );
}
