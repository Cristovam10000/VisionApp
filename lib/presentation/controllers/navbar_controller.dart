import 'package:flutter/material.dart';
import 'package:vision_app/presentation/pages/home/tela_home.dart';
import 'package:vision_app/presentation/pages/home/pop-up_facerules.dart';
import 'package:vision_app/presentation/pages/buscacpf/tela_busca_cpf.dart';

mixin NavbarController {
  void navigateNavbar({
    required BuildContext context,
    required int index,
    required int currentIndex,
    required Map<String, dynamic>? perfil,
    required String token,
  }) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TelaHome(perfil: perfil)),
        );
        break;
      case 1:
        mostrarPopUpRegrasFace(context: context, perfil: perfil);
        break;
      case 2:
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TelaBuscaCpf(token: token, perfil: perfil),
          ),
        );
        break;
    }
  }
}