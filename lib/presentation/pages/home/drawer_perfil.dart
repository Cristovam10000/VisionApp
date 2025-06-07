import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/core/constants/app_texts.dart';
import 'package:vision_app/presentation/widgets/state/formatacao.dart';
import 'package:vision_app/presentation/pages/home/pop-up_logout.dart';
import 'package:vision_app/presentation/widgets/state/infotextline.dart';

class CustomDrawer extends StatelessWidget {
  final String nomeCompleto;
  final String cargo;
  final String classe;
  final String matricula;

  const CustomDrawer({
    super.key,
    required this.nomeCompleto,
    required this.cargo,
    required this.classe,
    required this.matricula,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorPalette.dark,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Botão X para fechar
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.of(context).pop(); // Fecha o Drawer
                    },
                  ),
                ],
              ),
            ),

            Text(
              StandardTexts.appTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 24),
            Image.asset(
              'assets/star_logo.png',
              height: 55,
              width: 55,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: 200,
              child: Text(
                nomeCompleto,
                softWrap: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: ColorPalette.branco,
                ),
              ),
            ),
            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoTextLine('Cargo: ', cargo),
                    const SizedBox(height: 12),
                    infoTextLine('Classe: ', classe),
                    const SizedBox(height: 12),
                    infoTextLine('Matrícula: ', formatMatricula(matricula)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.logout, color: ColorPalette.lightbutton, size: 32),
                  label: const Text(
                    'Sair',
                    style: TextStyle(
                      color: ColorPalette.lightbutton,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  onPressed: () {
                    mostrarDialogoLogout(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: ColorPalette.lightbutton,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
