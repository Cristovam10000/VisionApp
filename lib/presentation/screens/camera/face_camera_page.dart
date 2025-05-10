import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math'; // Importação necessária para min e max
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
  bool _isFaceInPosition = false;
  bool _showMessage = false;
  
  // Tamanho do quadrado de detecção facial
  final double _faceBoxSize = 260.0;
  
  // Flag para controlar a rotação da câmera
  final bool _rotationCorrection = false; // Defina como true se precisar inverter as coordenadas
  
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
        
        // Verificar se tem algum rosto dentro da região quadrada
        bool faceInPosition = false;
        if (faces.isNotEmpty) {
          // Obter o tamanho da tela
          final screenSize = MediaQuery.of(context).size;
          
          // Calcular o centro e tamanho da região quadrada na tela
          final centerX = screenSize.width / 2;
          final centerY = screenSize.height / 2;
          final halfBoxSize = _faceBoxSize / 2;
          
          // Definir os limites da região quadrada
          final left = centerX - halfBoxSize;
          final top = centerY - halfBoxSize;
          final right = centerX + halfBoxSize;
          final bottom = centerY + halfBoxSize;
          
          // Calcular a escala da imagem para a tela
          final scaleX = screenSize.width / image.width;
          final scaleY = screenSize.height / image.height;

          // Adiciona logs para depuração
          print('👤 Faces detectadas: ${faces.length}');
          
          // Verificar se algum rosto está suficientemente dentro da região
          for (int i = 0; i < faces.length; i++) {
            final face = faces[i];
            print('📏 Face #$i: ${face.boundingBox.toString()}');
            
            // Calcular coordenadas do rosto na tela
            double faceLeft, faceTop, faceRight, faceBottom;
            
            // Se estiver em modo retrato e precisar inverter as coordenadas
            if (_rotationCorrection) {
              // Inverte X e Y devido à rotação da câmera
              faceLeft = face.boundingBox.top * scaleX;
              faceTop = image.width - face.boundingBox.right * scaleY;
              faceRight = face.boundingBox.bottom * scaleX;
              faceBottom = image.width - face.boundingBox.left * scaleY;
            } else {
              // Sem inversão
              faceLeft = face.boundingBox.left * scaleX;
              faceTop = face.boundingBox.top * scaleY;
              faceRight = face.boundingBox.right * scaleX;
              faceBottom = face.boundingBox.bottom * scaleY;
            }
            
            print('📱 Face #$i na tela: L:$faceLeft, T:$faceTop, R:$faceRight, B:$faceBottom');
            print('🎯 Quadrado de detecção: L:$left, T:$top, R:$right, B:$bottom');
            
            // Calcular intersecção entre o rosto e o quadrado de detecção
            final intersectionLeft = max(faceLeft, left);
            final intersectionTop = max(faceTop, top);
            final intersectionRight = min(faceRight, right);
            final intersectionBottom = min(faceBottom, bottom);
            
            // Se há intersecção válida
            if (intersectionLeft < intersectionRight && intersectionTop < intersectionBottom) {
              // Calcular áreas
              final intersectionArea = (intersectionRight - intersectionLeft) * 
                                    (intersectionBottom - intersectionTop);
              final faceArea = (faceRight - faceLeft) * (faceBottom - faceTop);
              
              final percentageInBox = faceArea > 0 ? (intersectionArea / faceArea) : 0;
              print('📊 Porcentagem do rosto no quadrado: ${(percentageInBox * 100).toStringAsFixed(1)}%');
              
              // Se pelo menos 70% do rosto estiver dentro do quadrado
              if (faceArea > 0 && percentageInBox > 0.7) {
                faceInPosition = true;
                break;
              }
            }
          }
        }
        
        setState(() {
          _faces = faces;
          _isFaceInPosition = faceInPosition;
          _showMessage = faces.isEmpty;
        });
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
      // Verificar se há um rosto na posição correta
      if (!_isFaceInPosition) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Posicione seu rosto corretamente dentro do quadrado verde'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
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
        
        // Feedback de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Imagem capturada e enviada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Erro ao capturar/Enviar imagem: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao capturar ou enviar imagem: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
          
          // Camada de desfoque (tudo fora do quadrado)
          CustomPaint(
            size: Size.infinite,
            painter: BlurPainter(_faceBoxSize),
          ),
          
          // Guia de posicionamento facial (sempre visível)
          Center(
            child: Container(
              width: _faceBoxSize,
              height: _faceBoxSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isFaceInPosition ? Colors.green : Colors.red, 
                  width: 3
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          // Desenha bounding boxes das faces detectadas
          CustomPaint(
            painter: FacePainter(
              _faces, 
              _cameraService.controller.value.previewSize!,
              _isFaceInPosition,
            ),
          ),
          
          // Mensagem quando não há rostos detectados
          if (_showMessage)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: EdgeInsets.only(top: 20 + _faceBoxSize/2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Nenhum rosto detectado',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
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
                  onPressed: _isFaceInPosition ? _captureAndUpload : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Posicione seu rosto corretamente antes de capturar'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  backgroundColor: _isFaceInPosition ? Colors.white : Colors.grey,
                  child: Icon(
                    Icons.camera_alt, 
                    color: _isFaceInPosition ? Colors.black : Colors.white60
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Classe para criar o efeito de desfoque fora da região quadrada
class BlurPainter extends CustomPainter {
  final double boxSize;
  
  BlurPainter(this.boxSize);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 3.0);
    
    // Calcular as dimensões do retângulo central (área que não será desfocada)
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final halfBoxSize = boxSize / 2;
    
    final rect = Rect.fromLTRB(
      centerX - halfBoxSize,
      centerY - halfBoxSize,
      centerX + halfBoxSize,
      centerY + halfBoxSize,
    );
    
    // Desenhar um caminho que cobre toda a tela exceto o retângulo central
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(rect)
      ..fillType = PathFillType.evenOdd;
    
    // Desenhar o efeito de desfoque
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}