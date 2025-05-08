import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_texts.dart';
// import '/routes/app_routes.dart';


class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage('assets/IconApp.png'), // Substitua pelo caminho correto da imagem
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            Text(StandardTexts.appTitle,
            style: Theme.of(context).textTheme.bodyLarge),

            TextField(
              decoration: const InputDecoration(labelText: 'Usuário'),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigator.pushNamed(context, AppRoutes.home);  // Navega para a tela de home
              },
              child: Text(
                'Entrar',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
