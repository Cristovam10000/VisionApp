import 'package:flutter/material.dart';
import 'package:vision_app/presentation/screens/buscacpf/tela_busca_cpf.dart';
import 'package:vision_app/presentation/screens/camera/face_camera_page.dart';
import 'package:vision_app/presentation/screens/home/tela_home.dart';


class CustomNavbar extends StatelessWidget {
  final int currentIndex;
  final Map<String, dynamic> perfil;
  final String? token;

  const CustomNavbar({super.key, required this.currentIndex, required this.perfil, this.token});



  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TelaHome(perfil: perfil,)));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FaceCameraPage(perfil: perfil,)));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TelaBuscaCpf(token: token, perfil: perfil)));
        break;
    }
  }

  @override
Widget build(BuildContext context) {
  return SizedBox(
    height: 80, // Altura desejada da barra
    child: BottomNavigationBar(
      backgroundColor: const Color(0xFF132D46),
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.white,
      currentIndex: currentIndex,
      onTap: (index) => _navigate(context, index),
      iconSize: 30,               // Tamanho dos ícones
      selectedFontSize: 16,       // Tamanho do texto selecionado
      unselectedFontSize: 14,     // Tamanho do texto não selecionado
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Câmera',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'CPF',
        ),
      ],
    ),
  );
}

}
