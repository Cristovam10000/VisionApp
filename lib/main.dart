import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'package:face_camera/face_camera.dart';  // Importe o pacote

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Erro ao inicializar Firebase: $e');
  }
  
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await FaceCamera.initialize();  // Inicialize o FaceCamera
  } catch (e) {
    print('Erro ao inicializar: $e');
  }
  
=======
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';  // Importando o arquivo de rotas
import 'presentation/screens/login/tela_login.dart';
import 'presentation/screens/home/tela_home.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
>>>>>>> login
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'Seu App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generate,
    );
  }
}

=======
      title: 'VisionApp',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,  // Tela inicial é o login
      routes: {
        AppRoutes.login: (context) => const TelaLogin(),
        AppRoutes.home: (context) => TelaHome(),
      },
    );
  }
}
>>>>>>> login
