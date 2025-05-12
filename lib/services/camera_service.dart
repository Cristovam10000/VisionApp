import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CameraService {
  late CameraController _controller;

  CameraController get controller => _controller;

  Future<bool> initializeCamera() async {

     if (kIsWeb) {
      print('Aviso: Funcionalidade de câmera pode ter limitações na web');
      // Tratamento específico para web, se necessário
    }
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        print('Nenhuma câmera disponível');
        return false;
      }
      
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      await _controller.initialize();
      return true;
    } catch (e) {
      print('Erro ao inicializar câmera: $e');
      return false;
    }
  }
  Future<XFile> takePicture() async {
    return await _controller.takePicture();
  }

  void dispose() {
    _controller.dispose();
  }
}