// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/presentation/screens/camera/face_camera_controller_setup.dart';
import 'package:vision_app/presentation/screens/camera/face_overlay.dart';
import 'package:vision_app/presentation/screens/camera/face_utils.dart';
import 'package:vision_app/presentation/screens/camera/popup_dialog_error_foto.dart';
import 'package:vision_app/presentation/widgets/state/loading_dialog.dart';
import 'dart:io';
import '../../../services/auth_token_service.dart';
import '../../../services/upload_service.dart';
import 'informacoes_obtidas.dart';

class FaceCameraPage extends StatefulWidget {
  final Map<String, dynamic>? perfil;
  const FaceCameraPage({super.key, this.perfil});

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
    _capturedImage = null;
    _controller = setupFaceCameraController(
      onCapture: (file) {
        if (file == null || _isProcessing) return;
        setState(() {
          _capturedImage = file;
        });
      },
      onFaceDetected: (face) {
        setState(() {
          _isFaceWellPositioned =
              face != null &&
              isFaceCentered(face.boundingBox, MediaQuery.of(context).size);
        });
      },
    );
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
    showLoadingDialog(
      context,
      mensagem: 'Enviando imagem e aguardando resultado...',
    );

    try {
      final token = AuthTokenService().token;
      if (token != null) {
        final resultado = await _uploadService.enviarImagem(
          _capturedImage!,
          token,
        );

        Navigator.pop(context);

        if (resultado['statusCode'] == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ResultadoPage(
                    resultado: resultado['body'],
                    perfil: widget.perfil,
                    token: token,
                  ),
            ),
          );
        } else {
          _showMessage(
            '❌ Erro ao enviar imagem. Código: ${resultado['statusCode']}',
            Colors.red,
          );
        }

        // Se tudo certo, segue normalmente
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ResultadoPage(
                  resultado: resultado,
                  perfil: widget.perfil,
                  token: token,
                ),
          ),
        ).then((_) async {
          await _controller.startImageStream();
          setState(() => _capturedImage = null);
        });
      } else {
        Navigator.pop(context);
        _showMessage('❌ Token não encontrado', Colors.red);
      }
    } catch (e) {
      Navigator.pop(context);
      _showMessage('❌ Erro: ${e.toString()}', Colors.red);
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
      appBar:
          _capturedImage == null
              ? AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ), // Troque para o ícone que quiser
                  onPressed: () {
                    Navigator.pop(
                      context,
                    ); // Mantém o comportamento padrão de voltar
                  },
                ),
              )
              : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_capturedImage != null)
            Stack(
              fit: StackFit.expand,
              children: [
                Image.file(_capturedImage!, fit: BoxFit.cover),
                Positioned(
                  bottom: 72,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.verdePaleta,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: _handleConfirmUpload,

                        child: const Icon(
                          Icons.check,
                          color: ColorPalette.branco,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 64),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.vermelhoPaleta,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: () async {
                          await _controller
                              .startImageStream(); // reinicia a câmera
                          setState(
                            () => _capturedImage = null,
                          ); // remove a imagem
                        },
                        child: const Icon(
                          Icons.close,
                          color: ColorPalette.branco,
                          size: 32,
                        ),
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
              captureControlBuilder: (context, detectedFace) {
                return IconButton(
                  icon: CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color.fromRGBO(3, 77, 162, 1),
                    foregroundColor: Colors.white,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.camera_alt,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed:
                      _controller.enableControls
                          ? _controller.captureImage
                          : null,
                );
              },
              flashControlBuilder: (context, flashMode) {
                IconData icon;
                switch (flashMode) {
                  case CameraFlashMode.always:
                    icon = Icons.flash_on;
                    break;
                  case CameraFlashMode.off:
                    icon = Icons.flash_off;
                    break;
                  case CameraFlashMode.auto:
                  default:
                    icon = Icons.flash_auto;
                }

                return IconButton(
                  icon: CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color.fromRGBO(3, 77, 162, 1),
                    foregroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(icon, size: 25, color: Colors.white),
                    ),
                  ),
                  onPressed:
                      _controller.enableControls
                          ? _controller.changeFlashMode
                          : null,
                );
              },
            ),

          if (_capturedImage == null) const FaceOverlay(),

          if (_isProcessing) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
