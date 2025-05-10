import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../../services/camera_service.dart';
import '../../../services/face_detection_service.dart';
import '../../../services/auth_token_service.dart';
import '../../../services/upload_service.dart';
import '../../widgets/state/face_pointer.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceCameraPage extends StatefulWidget {
  const FaceCameraPage({super.key});

  @override
  _FaceCameraPageState createState() => _FaceCameraPageState();
}

class _FaceCameraPageState extends State<FaceCameraPage> {
  final CameraService _cameraService = CameraService();
  final FaceDetectionService _faceService = FaceDetectionService();
  final UploadService _uploadService = UploadService();
  bool _isLoading = true;
  bool _flashOn = false;
  List<Face> _faces = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final ok = await _cameraService.initializeCamera();
    if (ok) {
      // Para processar frames em tempo real:
      _cameraService.controller.startImageStream((image) async {
        final faces = await _faceService.detectFacesFromImage(image);
        setState(() => _faces = faces);
      });
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _cameraService.controller.stopImageStream();
    _cameraService.dispose();
    _faceService.dispose();
    super.dispose();
  }

  void _toggleFlash() async {
    _flashOn = !_flashOn;
    await _cameraService.controller.setFlashMode(
      _flashOn ? FlashMode.torch : FlashMode.off
    );
    setState(() {});
  }

  Future<void> _captureAndUpload() async {
    try {
      // Desliga o flash antes de capturar, se estiver ligado
      final currentFlashState = _flashOn;
      
      if (_flashOn) {
        await _cameraService.controller.setFlashMode(FlashMode.off);
      }
      
      // Configura flash apenas para a foto, se necessário
      await _cameraService.controller.setFlashMode(
        currentFlashState ? FlashMode.auto : FlashMode.off
      );
      
      final picture = await _cameraService.takePicture();
      
      // Restaura estado anterior do flash
      await _cameraService.controller.setFlashMode(
        currentFlashState ? FlashMode.torch : FlashMode.off
      );
      
      final token = AuthTokenService().token;
      if (token != null) {
        await _uploadService.enviarImagem(File(picture.path), token);
      }
    } catch (e) {
      print('Erro ao capturar/Enviar imagem: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detecção Facial'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Preview da câmera
          CameraPreview(_cameraService.controller),
          
          // Guia de posicionamento facial (sempre visível)
          Center(
            child: Container(
              width: 280,
              height: 350,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(150),
              ),
            ),
          ),
          
          // Desenha bounding boxes das faces detectadas
          CustomPaint(
            painter: FacePainter(_faces, _cameraService.controller.value.previewSize!),
          ),
          
          // Botões de controle na parte inferior
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botão de flash
                FloatingActionButton(
                  heroTag: 'flashButton',
                  onPressed: _toggleFlash,
                  backgroundColor: Colors.grey[800],
                  mini: true,
                  child: Icon(
                    _flashOn ? Icons.flash_on : Icons.flash_off,
                    color: _flashOn ? Colors.amber : Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                // Botão de captura
                FloatingActionButton(
                  heroTag: 'cameraButton',
                  onPressed: _captureAndUpload,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.camera_alt, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}