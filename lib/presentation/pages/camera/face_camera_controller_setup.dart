import 'dart:io';
import 'package:face_camera/face_camera.dart';


FaceCameraController setupFaceCameraController({
  required void Function(File?) onCapture,
  required void Function(Face?) onFaceDetected,
}) {
  return FaceCameraController(
    autoCapture: false,
    defaultCameraLens: CameraLens.back,
    defaultFlashMode: CameraFlashMode.off,
    enableAudio: false,
    onCapture: onCapture,
    onFaceDetected: onFaceDetected,
  );
}
