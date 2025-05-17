import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, {String? mensagem}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: const Color(0xFF132D46), // escurece o fundo da tela
    builder: (BuildContext context) {
      return const Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.white,
          ),
        ),
      );
    },
  );
}

void dismissLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
