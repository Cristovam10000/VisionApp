<<<<<<< HEAD
import 'package:flutter/material.dart';
import '../presentation/screens/login/login_page.dart';
import '../presentation/screens/home/home_page.dart';
import '../presentation/screens/camera/face_camera_page.dart';

class AppRoutes {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/home':
        final perfil = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => HomePage(perfil: perfil));
      case '/camera':
      // aqui tinha um const  FaceCameraPage());
        return MaterialPageRoute(builder: (_) =>  FaceCameraPage());
      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('Rota não encontrada')),
              ),
        );
    }
  }
}
=======
class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
}
>>>>>>> login
