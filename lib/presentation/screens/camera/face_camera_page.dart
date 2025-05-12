import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'dart:io';
import '../../../services/auth_token_service.dart';
import '../../../services/upload_service.dart';
import 'package:camera/camera.dart';
import '../camera/informacoes.dart';

class FaceCameraPage extends StatefulWidget {
  const FaceCameraPage({super.key});

  @override
  _FaceCameraPageState createState() => _FaceCameraPageState();
}

class _FaceCameraPageState extends State<FaceCameraPage> {
  late FaceCameraController _controller;
  File? _capturedImage;
  bool _isProcessing = false;
  final UploadService _uploadService = UploadService();

  // Flags de rosto detectado
  bool _isFaceVisible = false;
  bool _isFaceWellPositioned = false;

  @override
  void initState() {
    super.initState();
    _controller = FaceCameraController(
      autoCapture: false,
      defaultCameraLens: CameraLens.back,
      enableAudio: false,
      onCapture: (file) {
        if (file == null || _isProcessing || !_isFaceVisible || !_isFaceWellPositioned) return;
        setState(() {
          _capturedImage = file;
        });
      },
      onFaceDetected: (face) {
        setState(() {
          _isFaceVisible = face != null;
          _isFaceWellPositioned = face != null && _isFaceCentered(face.boundingBox, MediaQuery.of(context).size);
          

        });
      },
    );


    
  }


  bool _isFaceCentered(Rect boundingBox, Size screenSize) {
  final centerX = boundingBox.center.dx;
  final centerY = boundingBox.center.dy;

  final screenCenterX = screenSize.width / 2;
  final screenCenterY = screenSize.height / 2.7;

  const toleranceX = 60; // ajuste fino aqui
  const toleranceY = 80;

  return (centerX - screenCenterX).abs() < toleranceX &&
         (centerY - screenCenterY).abs() < toleranceY;
}


  Future<void> _handleConfirmUpload() async {
  if (_capturedImage == null || _isProcessing) return;

  setState(() => _isProcessing = true);

  try {
    final token = AuthTokenService().token;
    if (token != null) {
      final resultado = await _uploadService.enviarImagem(_capturedImage!, token);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadoPage(resultado: resultado),
        ),
      );

      setState(() => _capturedImage = null);
      await _controller.startImageStream();
    } else {
      _showMessage('❌ Token não encontrado', Colors.red);
    }
  } catch (e) {
    _showMessage('❌ Erro ao enviar imagem: $e', Colors.red);
  } finally {
    setState(() => _isProcessing = false);
  }
}


  void _showMessage(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_capturedImage != null)
            Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  _capturedImage!,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  const Color(0xFF034DA2),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: _handleConfirmUpload,
                        child: const Icon(Icons.check, color: Color.fromARGB(255, 255, 255, 255), size: 32),
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 224, 10, 10),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: () async {
                          await _controller.startImageStream();
                          setState(() => _capturedImage = null);
                        },
                        child: const Icon(Icons.close, color: Color.fromARGB(255, 255, 255, 255), size: 32),
                      ),

                    ],
                  ),
                ),
              ],
            )
          else
            SmartFaceCamera(
              controller: _controller,
              messageBuilder: (context, face) {
                if (!_isFaceVisible) {
                  return _message('Nenhum rosto detectado');
                } else if (!_isFaceWellPositioned) {
                  return _message('Centralize o rosto corretamente');
                }
                return const SizedBox.shrink();
              },
            ),

          if (_capturedImage == null) const FaceOverlay(),

          if (_isProcessing)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 30, color: Color.fromARGB(255, 255, 0, 0), fontWeight: FontWeight.bold),
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Overlay com foco circular
class FaceOverlay extends StatelessWidget {
  const FaceOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: FaceOverlayPainter(),
        ),
      ),
    );
  }
}

class FaceOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 54, 54, 54).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final holeRadius = size.width * 0.35;
    final center = Offset(size.width / 2, size.height / 2.7);

    // Define o raio e a posição dos círculos para os botões
    final buttonRadius = 32.0; // Raio dos botões
    final buttonPadding = 25.9; // Espaço entre os botões e a borda da tela

    // Ajusta o retângulo para cobrir toda a tela
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Exclui o círculo transparente no centro
    path.addOval(Rect.fromCircle(center: center, radius: holeRadius));

    // Exclui o círculo do botão de confirmação
    // Exclui o círculo do botão de confirmação
final confirmButtonCenter = Offset(
  size.width / 2 - buttonRadius * 2 - buttonPadding, // Reduz o espaçamento horizontal
  size.height - buttonRadius - buttonPadding, // Posição vertical
);
path.addOval(Rect.fromCircle(center: confirmButtonCenter, radius: buttonRadius));

// Exclui o círculo do botão de cancelamento
final cancelButtonCenter = Offset(
  size.width / 2 + buttonRadius * 2 + buttonPadding, // Reduz o espaçamento horizontal
  size.height - buttonRadius - buttonPadding, // Posição vertical
);
path.addOval(Rect.fromCircle(center: cancelButtonCenter, radius: buttonRadius));

    // Exclui o círculo do botão adicional (central)
    final additionalButtonCenter = Offset(
      size.width / 2, // Posição horizontal (centro)
      size.height - buttonRadius - buttonPadding, // Posição vertical
    );
    path.addOval(Rect.fromCircle(center: additionalButtonCenter, radius: buttonRadius));

    path.fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}