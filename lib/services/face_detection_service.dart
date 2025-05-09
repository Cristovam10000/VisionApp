// lib/services/face_detection_service.dart

// para WriteBuffer e Uint8List
import 'package:flutter/foundation.dart'; // para WriteBuffer
import 'package:flutter/material.dart';  // para Size
import 'package:camera/camera.dart';  // para CameraImage
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionService {
  final FaceDetector _faceDetector = FaceDetector(
    options:  FaceDetectorOptions(
      enableContours: false,
      enableClassification: false,
    ),
  );

  /// Recebe um [CameraImage], converte para [InputImage] e detecta faces.
  Future<List<Face>> detectFacesFromImage(CameraImage image) async {
    // 1) Junta todos os bytes dos planos em um único buffer
    final allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    // 2) Cria o InputImage com metadados obrigatórios
    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(
          image.width.toDouble(),
          image.height.toDouble(),
        ),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormatValue.fromRawValue(image.format.raw) 
            ?? InputImageFormat.nv21,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );

    // 3) Processa a imagem e retorna a lista de faces detectadas
    return _faceDetector.processImage(inputImage);
  }

  /// Libera recursos do detector
  void dispose() {
    _faceDetector.close();
  }
}
