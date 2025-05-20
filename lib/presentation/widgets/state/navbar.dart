import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/presentation/screens/buscacpf/tela_busca_cpf.dart';
import 'package:vision_app/presentation/screens/camera/face_camera_page.dart';
import 'package:vision_app/presentation/screens/home/pop-up_facerules.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';

class CustomNavbar extends StatelessWidget {
  final int currentIndex;
  final Map<String, dynamic> perfil;
  final String token;

  const CustomNavbar({
    super.key,
    required this.currentIndex,
    required this.perfil,
    required this.token,
  });

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TelaHome(perfil: perfil)),
        );
        break;
      case 1:
        mostrarPopUpRegrasFace(context: context, perfil: perfil);
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TelaBuscaCpf(token: token, perfil: perfil),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool nenhumSelecionado = currentIndex == -1;

    return SizedBox(
      height: 80,
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: ColorPalette.navbar,
          selectedItemColor:
              nenhumSelecionado ? Colors.white : ColorPalette.lightbutton,
          unselectedItemColor: Colors.white,
          currentIndex: nenhumSelecionado ? 0 : currentIndex,
          onTap: (index) => _navigate(context, index),
          iconSize: 30,
          selectedFontSize: 16,
          unselectedFontSize: 14,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined),
              label: 'Câmera',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'CPF'),
          ],
        ),
      ),
    );
  }
}
