import 'package:flutter/material.dart';
import '../presentation/screens/login/tela_login.dart';
import '../presentation/screens/home/tela_home.dart';
import '../presentation/screens/camera/face_camera_page.dart';
import '../presentation/screens/buscacpf/tela_busca_cpf.dart';

class AppRoutes {
  // Definição das rotas como constantes
  static const String login = '/login';
  static const String home = '/home';
  static const String camera = '/camera';
  static const String buscaCpf = '/busca-cpf';

  // Método para gerar rotas dinamicamente
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const TelaLogin());
      case home:
        final perfil = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => TelaHome(perfil: perfil));
      case camera:
        return MaterialPageRoute(builder: (_) => FaceCameraPage());
      case buscaCpf:
        final token = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => TelaBuscaCpf(token: token),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }
}