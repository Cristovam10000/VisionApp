import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';  // Importando o arquivo de rotas
import 'presentation/screens/login/tela_login.dart';
// import 'presentation/screens/home/tela_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VisionApp',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,  // Tela inicial é o login
      routes: {
        AppRoutes.login: (context) => const TelaLogin(),
       // AppRoutes.home: (context) => const TelaHome(),
      },
    );
  }
}
