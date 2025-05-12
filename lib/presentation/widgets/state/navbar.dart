import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/routes/app_routes.dart';

class navbarContainer extends StatefulWidget {
  @override
  _navbarState createState() => _navbarState();
}

class _navbarState extends State<navbarContainer> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0: // Home
        Navigator.pushNamed(context, AppRoutes.home);
        break;
      case 1: // Camera
        Navigator.pushNamed(context, AppRoutes.camera);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Color.fromRGBO(19, 39, 61, 1), // Cor de fundo da navbar
      ),
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.home_outlined, size: 24), // Ícone
                SizedBox(height: 6), // Espaçamento entre ícone e label
                Text(
                  'Home',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            label: '', // Removemos o label padrão
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.camera_alt_outlined, size: 24), // Ícone
                SizedBox(height: 6), // Espaçamento entre ícone e label
                Text(
                  'Câmera',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            label: '', // Removemos o label padrão
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.search, size: 24), // Ícone
                SizedBox(height: 6), // Espaçamento entre ícone e label
                Text(
                  'CPF',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            label: '', // Removemos o label padrão
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorPalette.branco,
        unselectedItemColor: ColorPalette.branco,
        backgroundColor: ColorPalette.azulEscuro, // já definido no container
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        elevation: 0, // remove sombra
      ),
    );
  }
}
