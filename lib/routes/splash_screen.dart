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
    Future.delayed(Duration(seconds: 10), () {
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
      body: Center(
        child: CircularProgressIndicator(), // ou uma imagem/logo
      ),
    );
  }
}