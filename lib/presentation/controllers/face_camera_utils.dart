import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'dart:io';
import '../../core/services/auth_token_service.dart';
import '../../core/services/upload_service.dart';
import '../pages/camera/informacoes_obtidas.dart';
import '../pages/camera/popup_dialog_error_foto.dart';
import '../widgets/loading_dialog.dart';



CameraFlashMode toggleFlashMode({
  required CameraFlashMode currentFlashMode,
  required FaceCameraController controller,
}) {
  CameraFlashMode nextMode;
  switch (currentFlashMode) {
    case CameraFlashMode.auto:
      nextMode = CameraFlashMode.always;
      break;
    case CameraFlashMode.always:
      nextMode = CameraFlashMode.off;
      break;
    case CameraFlashMode.off:
      nextMode = CameraFlashMode.auto;
      break;
  }
  controller.changeFlashMode();
  return nextMode;
}


void showMessage(
  BuildContext context,
  String message,
  Color color,
  Map<String, dynamic>? perfil,
) {
  if (!Navigator.of(context).mounted) return;
  Navigator.pop(context, true);
  showErrorFotoDialog(context, perfil);
}

Future<void> handleConfirmUpload({
  required BuildContext context,
  required File? capturedImage,
  required bool isProcessing,
  required bool isFaceWellPositioned,
  required void Function(bool) setProcessing,
  required FaceCameraController controller,
  required Map<String, dynamic>? perfil,
  required UploadService uploadService,
}) async {
  if (capturedImage == null || isProcessing || !isFaceWellPositioned) {
    if (!Navigator.of(context).mounted) return;
    showMessage(
      context,
      '❌ Rosto não encontrado ou centralizado. Tente novamente.',
      const Color.fromARGB(255, 185, 134, 130),
      perfil,
    );
    return;
  }

  setProcessing(true);
  showLoadingDialog(
    context,
    mensagem: 'Enviando imagem e aguardando resultado...',
  );

  try {
    final token = AuthTokenService().token;
    if (token != null) {
      final resultado = await uploadService.enviarImagem(
        perfil?['matricula'],
        capturedImage,
        token,
      );

      Navigator.pop(context);

      if (resultado['statusCode'] == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultadoPage(
              resultado: resultado['body'],
              perfil: perfil,
              token: token,
            ),
          ),
        );
      } else {
        showMessage(
          context,
          '❌ Erro ao enviar imagem. Código: ${resultado['statusCode']}',
          Colors.red,
          perfil,
        );
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadoPage(
            resultado: resultado,
            perfil: perfil,
            token: token,
          ),
        ),
      ).then((_) async {
        await controller.startImageStream();
        // O reset do capturedImage deve ser feito no setState do widget
      });
    } else {
      Navigator.pop(context);
      showMessage(context, '❌ Token não encontrado', Colors.red, perfil);
    }
  } catch (e) {
    Navigator.pop(context);
    showMessage(context, '❌ Erro: ${e.toString()}', Colors.red, perfil);
  } finally {
    setProcessing(false);
  }
}