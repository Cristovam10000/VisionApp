import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_texts.dart';
import '../login/widgets.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/logo.png',
            ), // Substitua pelo caminho correto da imagem
            fit: BoxFit.cover, // Ajusta a imagem para cobrir toda a tela
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Image(
                image: AssetImage('assets/IconApp.png'),
                width: 143,
                height: 121,
              ),
              const SizedBox(height: 20),
              Text(
                StandardTexts.appTitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 32, // Define o tamanho da fonte
                  fontWeight: FontWeight.w700, // Define o texto como negrito
                ),
              ),
              const SizedBox(height: 20),
              Text(
                StandardTexts.appSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16, // Define o tamanho da fonte
                  fontWeight: FontWeight.w400, // Define o texto como normal
                ),
              ),
              const SizedBox(height: 200
              ),
              Logincontainer(),
            ],
          ),
        ),
      ),
    );
  }
}
