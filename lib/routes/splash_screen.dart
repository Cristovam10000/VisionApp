import 'package:flutter/material.dart';
import 'package:vision_app/presentation/screens/login/tela_login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Espera 3 segundos e navega para a tela de login
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => TelaLogin()),
        (route) => false, // remove todas as rotas anteriores
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF151B22), // Cor de fundo da tela
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/IconApp.png', // Caminho para a imagem do logo
              width: 200, // Largura da imagem
              height: 200, // Altura da imagem
            ),
            SizedBox(height: 20), // Espaço entre o ícone e o loading
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 6.0,
            ),
          ],
        ),
      ),
    );
  }
}
