// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/presentation/pages/home/tela_home.dart';
import 'package:vision_app/presentation/pages/login/tela_login.dart';
import 'package:vision_app/core/services/auth_backend_service.dart';
import 'package:vision_app/core/services/local_storage_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
    // Espera 3 segundos e navega para a tela de login
    Future.delayed(Duration(seconds: 2), () {
      FocusScope.of(context).unfocus();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => TelaLogin()),
        (route) => false, // remove todas as rotas anteriores
      );
    });
  }

  void _checkLogin() async {
  final token = await LocalStorageService().getToken();
  if (token != null) {
    final perfil = await getUserProfile(token);
    if (perfil != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TelaHome(perfil: perfil),
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.dark, // Cor de fundo da tela
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
              valueColor: AlwaysStoppedAnimation<Color>(ColorPalette.lightbutton),
              strokeWidth: 3.0,
            ),
          ],
        ),
      ),
    );
  }
}
