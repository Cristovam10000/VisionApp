import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import '../controllers/navbar_controller.dart';

class CustomNavbar extends StatelessWidget with NavbarController {
  final int currentIndex;
  final Map<String, dynamic>? perfil;
  final String token;

  const CustomNavbar({
    super.key,
    required this.currentIndex,
    this.perfil,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    final bool nenhumSelecionado = currentIndex == -1;

    return SizedBox(
      height: 100,
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: ColorPalette.navbar,
          selectedItemColor:
              nenhumSelecionado
                  ? ColorPalette.branco
                  : ColorPalette.lightbutton,
          unselectedItemColor: ColorPalette.branco,
          currentIndex: nenhumSelecionado ? 0 : currentIndex,
          onTap: (index) => navigateNavbar(
            context: context,
            index: index,
            currentIndex: currentIndex,
            perfil: perfil,
            token: token,
          ),
          iconSize: 30,
          selectedLabelStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Câmera',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'CPF'),
          ],
        ),
      ),
    );
  }
}
