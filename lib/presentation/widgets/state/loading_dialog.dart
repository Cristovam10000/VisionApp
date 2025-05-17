import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, {String? mensagem}) {
  showDialog(
    context: context,
    barrierDismissible: false, // impede o fechamento tocando fora
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              if (mensagem != null) ...[
                const SizedBox(height: 20),
                Text(
                  mensagem,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ]
            ],
          ),
        ),
      );
    },
  );
}

void dismissLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
