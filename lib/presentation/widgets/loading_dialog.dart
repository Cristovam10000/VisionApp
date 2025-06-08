import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';

void showLoadingDialog(BuildContext context, {String? mensagem}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: ColorPalette.azulMarinho, // escurece o fundo da tela
    builder: (BuildContext context) {
      return const Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: ColorPalette.branco,
          ),
        ),
      );
    },
  );
}

void dismissLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
