import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_texts.dart';
import 'package:vision_app/presentation/screens/home/pop-up_logout.dart';

class CustomDrawer extends StatelessWidget {
  final String nomeCompleto;
  final String cargo;
  final String classe;
  final String matricula;

  const CustomDrawer({
    Key? key,
    required this.nomeCompleto,
    required this.cargo,
    required this.classe,
    required this.matricula,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromRGBO(21, 27, 34, 1),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Text(
              StandardTexts.appTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 32,
                fontWeight:
                    FontWeight.w700 // Define o texto como negrito
              ),
            ),
            const SizedBox(height: 24),
            Image.asset(
                'assets/star_logo.png',
                height: 55,
                width: 55,
              ),
            const SizedBox(height: 24),
            Text(
              nomeCompleto,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.white,
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
                    infoTextLine('Matrícula: ', matricula),
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
                  icon: const Icon(Icons.logout, color: Color(0xFF0B5ED7), size: 32),
                  label: const Text(
                    'Sair',
                    style: TextStyle(
                      color: Color(0xFF0B5ED7),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  onPressed: () {
                    mostrarDialogoLogout(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF0B5ED7),
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

  Widget infoTextLine(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 18, color: Colors.white),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
