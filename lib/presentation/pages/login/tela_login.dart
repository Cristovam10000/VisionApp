import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_texts.dart';
import 'container_login_entrada.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Conteúdo superior com logo e textos
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  const Image(
                    image: AssetImage('assets/IconApp.png'),
                    width: 143,
                    height: 121,
                  ),
                  Text(
                    StandardTexts.appTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 32,
                      fontWeight:
                          FontWeight.w700 // Define o texto como negrito
                    ),
                  ),
                  const SizedBox(height: 11),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34),
                    child: Text(
                      StandardTexts.appDescription,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 215),
          // Container colado embaixo
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
              child: Logincontainer(),
            ),
          ),
        ],
      ),
    );
  }
}
