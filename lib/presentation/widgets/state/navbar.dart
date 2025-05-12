import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/routes/app_routes.dart';

class navbarContainer extends StatefulWidget {
  @override
  _navbarState createState() => _navbarState();
}

class _navbarState extends State<navbarContainer> {
  int _selectedIndex = 0; // Índice inicial do item selecionado

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Atualiza o índice selecionado
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
              children: [
                Icon(
                  Icons.home_outlined,
                  size: 24,
                  color: _selectedIndex == 0
                      ? ColorPalette.lightbutton // Cor do item selecionado
                      : Colors.white, // Cor do item não selecionado
                ),
                const SizedBox(height: 6),
                Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _selectedIndex == 0
                        ? ColorPalette.lightbutton// Cor do texto selecionado
                        : Colors.white, // Cor do texto não selecionado
                  ),
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 24,
                  color: _selectedIndex == 1
                      ? ColorPalette.lightbutton // Cor do item selecionado
                      : Colors.white, // Cor do item não selecionado
                ),
                const SizedBox(height: 6),
                Text(
                  'Câmera',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _selectedIndex == 1
                        ? ColorPalette.lightbutton // Cor do texto selecionado
                        : ColorPalette.branco, // Cor do texto não selecionado
                  ),
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search,
                  size: 24,
                  color: _selectedIndex == 2
                      ? ColorPalette.lightbutton // Cor do item selecionado
                      : ColorPalette.branco, // Cor do item não selecionado
                ),
                const SizedBox(height: 6),
                Text(
                  'CPF',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _selectedIndex == 2
                        ? ColorPalette.lightbutton // Cor do texto selecionado
                        : ColorPalette.branco, // Cor do texto não selecionado
                  ),
                ),
              ],
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorPalette.lightbutton, // Cor do item selecionado
        unselectedItemColor: Colors.white, // Cor dos itens não selecionados
        backgroundColor: ColorPalette.azulEscuro,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        enableFeedback: false,
        elevation: 0, // Remove sombra
      ),
    );
  }
}