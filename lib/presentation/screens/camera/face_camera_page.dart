import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:vision_app/presentation/screens/camera/popup_dialog_error_foto.dart';
import 'package:vision_app/presentation/widgets/state/loading_dialog.dart';
import 'dart:io';
import '../../../services/auth_token_service.dart';
import '../../../services/upload_service.dart';
import '../camera/informacoes.dart';

class FaceCameraPage extends StatefulWidget {
  final Map<String, dynamic> perfil;
  const FaceCameraPage({super.key, required this.perfil});

  @override
  _FaceCameraPageState createState() => _FaceCameraPageState();
}

class _FaceCameraPageState extends State<FaceCameraPage> {
  late FaceCameraController _controller;
  File? _capturedImage;
  bool _isProcessing = false;
  final UploadService _uploadService = UploadService();

  // Flags de rosto detectado
  // bool _isFaceVisible = false;
  bool _isFaceWellPositioned = false;

  @override
  void initState() {
    super.initState();
    _controller = FaceCameraController(
      autoCapture: false,
      defaultFlashMode: CameraFlashMode.off,
      defaultCameraLens: CameraLens.back,
      enableAudio: false,
      onCapture: (file) {
        if (file == null || _isProcessing  ) return;
        setState(() {
          _capturedImage = file;
        });
      },
      onFaceDetected: (face) {
        setState(() {
          // _isFaceVisible = face != null;
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
  if (_capturedImage == null || _isProcessing || !_isFaceWellPositioned) {
    if (!mounted) return;
    _showMessage(
      '❌ Rosto não encontrado ou centralizado. Tente novamente.',
      const Color.fromARGB(255, 185, 134, 130),
    );
    return;
  }

  setState(() => _isProcessing = true);
  showLoadingDialog(context, mensagem: 'Enviando imagem e aguardando resultado...');

  try {
    final token = AuthTokenService().token;
    if (token != null) {
      final resultado = await _uploadService.enviarImagem(_capturedImage!, token);

      if (!mounted) return;

      Navigator.pop(context); // Fecha o diálogo de loading

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadoPage(
            resultado: resultado,
            perfil: widget.perfil,
          ),
        ),
      ).then((_) async {
        await _controller.startImageStream();
        setState(() => _capturedImage = null);
      });
    } else {
      Navigator.pop(context); // Fecha o diálogo de loading
      _showMessage('❌ Token não encontrado', Colors.red);
    }
  } catch (e) {
    Navigator.pop(context); // Fecha o diálogo de loading

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultadoPage(
          resultado: {'erro': e.toString()},
          perfil: widget.perfil,
        ),
      ),
    );
    _capturedImage = null;
  } finally {
    setState(() => _isProcessing = false);
  }
}



 void _showMessage(String message, Color color) {
  if (!mounted) return;

  Navigator.pop(context, true);
  showErrorFotoDialog(context, widget.perfil);

  

}


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: _capturedImage == null
        ? AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0, 
          )
        : null,
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
                  bottom: 72,
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
                      const SizedBox(width: 64),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 224, 10, 10),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: () async {
                          await _controller.startImageStream(); // reinicia a câmera
                          setState(() => _capturedImage = null); // remove a imagem

                        },
                        child: const Icon(Icons.close, color: Colors.white, size: 32),
                      ),

                    ],
                  ),
                ),
              ],
            )
          else
            SmartFaceCamera(
              controller: _controller,
              indicatorShape: IndicatorShape.none,
              showCameraLensControl: false,
              messageStyle: const TextStyle(
                fontSize: 40,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              messageBuilder: (context, face) {
                
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

  // Widget _message(String msg) => Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Text(
  //         msg,
  //         textAlign: TextAlign.center,
  //         style: const TextStyle(fontSize: 30, color: Color.fromARGB(255, 255, 0, 0), fontWeight: FontWeight.bold),
  //       ),
  //     );

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

// ...existing code...
class FaceOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 54, 54, 54).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Dimensões e posição do retângulo (ajuste para proporção da tela)
    final rectWidth = 282.0;
    final rectHeight = 452.0;
    final rectLeft = 47.0;
    final rectTop = 121.0;
    final borderRadius = 280.0;

    // === Círculos para os botões ===
    final buttonRadius = 38.0;
    final ycapture = size.height - 62;
    final yflash = size.height - 62;
    final captureX = size.width / 1.715;
    final flashX = size.width / 3;

    // Path cobrindo toda a tela
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Recorte do retângulo central com bordas arredondadas
    final rect = Rect.fromLTWH(rectLeft, rectTop, rectWidth, rectHeight);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    path.addRRect(rrect);

    // Recorte dos círculos dos botões (deixa "vazado" no overlay)
    path.addOval(Rect.fromCircle(center: Offset(captureX, ycapture), radius: buttonRadius));
    path.addOval(Rect.fromCircle(center: Offset(flashX, yflash), radius: buttonRadius));

    path.fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);

    // Borda do retângulo
    final borderPaint = Paint()
      ..color = const Color.fromARGB(255, 8, 60, 102)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawRRect(rrect, borderPaint);

    // Bordas dos círculos dos botões
    final circleBorderPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(Offset(captureX, ycapture), buttonRadius, circleBorderPaint);
    canvas.drawCircle(Offset(flashX, yflash), buttonRadius, circleBorderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
// ...existing code...