import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vision_app/routes/splash_screen.dart';
import 'firebase_options.dart';
import 'package:face_camera/face_camera.dart'; 
import 'core/theme/app_theme.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização do Firebase
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Erro ao inicializar Firebase: $e');
  }

  // Inicialização do FaceCamera
  try {
    await FaceCamera.initialize();
  } catch (e) {
    print('Erro ao inicializar FaceCamera: $e');
  }

  // Configuração do modo de interface do sistema
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Inicialização do aplicativo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VisionApp',
      home: SplashScreen(),
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}