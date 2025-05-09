import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import '../../../services/camera_service.dart';
import '../../../services/face_detection_service.dart';
import '../../../services/auth_token_service.dart';
import '../../../services/upload_service.dart';

class FaceCameraPage extends StatefulWidget {
  const FaceCameraPage({Key? key}) : super(key: key);

  @override
  State<FaceCameraPage> createState() => _FaceCameraPageState();
}

class _FaceCameraPageState extends State<FaceCameraPage> {
  final CameraService _cameraService = CameraService();
  final FaceDetectionService _faceDetectionService = FaceDetectionService();
  final UploadService _uploadService = UploadService();
  bool _isInitialized = false;
  bool _isCameraAvailable = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final success = await _cameraService.initializeCamera();
      if (success) {
        setState(() {
          _isInitialized = true;
          _isCameraAvailable = true;
        });
      } else {
        setState(() {
          _isInitialized = true;
          _isCameraAvailable = false;
          _errorMessage = 'Não foi possível inicializar a câmera';
        });
      }
    } catch (e) {
      setState(() {
        _isInitialized = true;
        _isCameraAvailable = false;
        _errorMessage = 'Erro ao inicializar a câmera: $e';
      });
      print('Erro na inicialização da câmera: $e');
    }
  }

  Future<void> _takePicture() async {
    try {
      final imageFile = await _cameraService.takePicture();
      
      // Verificar se a imagem foi capturada
      if (imageFile != null) {
        // Detectar faces na imagem
        final faces = await _faceDetectionService.detectFaces(imageFile.path);
        
        if (faces.isNotEmpty) {
          // Obter o token de autenticação
          final token = AuthTokenService().token;
          
          if (token != null) {
            // Enviar a imagem para o servidor
            await _uploadService.enviarImagem(File(imageFile.path), token);
            
            // Mostrar mensagem de sucesso
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Imagem capturada e enviada com sucesso!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Token de autenticação não encontrado')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nenhum rosto detectado na imagem')),
          );
        }
      }
    } catch (e) {
      print('Erro ao capturar imagem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao processar imagem: $e')),
      );
    }
  }

  @override
  void dispose() {
    if (_isCameraAvailable) {
      _cameraService.dispose();
    }
    _faceDetectionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isCameraAvailable) {
      return Scaffold(
        appBar: AppBar(title: const Text('Câmera')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage ?? 'Câmera indisponível', 
                 style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 24),
              if (kIsWeb) const Text(
                'Em navegadores, você pode precisar conceder permissão de câmera',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Câmera Facial')),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_cameraService.controller),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _takePicture,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              child: const Icon(Icons.camera_alt, size: 36),
            ),
          ),
        ],
      ),
    );
  }
}