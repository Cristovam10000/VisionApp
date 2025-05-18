import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';


class CameraService {
  late CameraController _controller;

  CameraController get controller => _controller;

  Future<bool> initializeCamera() async {

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (kDebugMode) {
          print('Nenhuma câmera disponível');
        }
        return false;
      }
      
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      await _controller.initialize();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao inicializar câmera: $e');
      }
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