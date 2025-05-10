// lib/services/face_detection_service.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:typed_data';

class FaceDetectionService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      enableLandmarks: true,
      minFaceSize: 0.05,  // Reduzido para 5% da imagem para maior sensibilidade
      performanceMode: FaceDetectorMode.accurate, // Mudando para modo mais preciso
    ),
  );

  /// Método melhorado para converter o CameraImage para InputImage
  Future<List<Face>> detectFacesFromImage(CameraImage cameraImage, {InputImageRotation rotation = InputImageRotation.rotation0deg}) async {
    try {
      // Correção: Melhor abordagem para converter CameraImage para InputImage
      final inputImage = _convertCameraImageToInputImage(cameraImage, rotation);
      if (inputImage == null) {
        print('Erro: Não foi possível converter a imagem.');
        return [];
      }

      // Processa a imagem e retorna a lista de faces detectadas
      return await _faceDetector.processImage(inputImage);
    } catch (e) {
      print('Erro ao detectar faces: $e');
      return [];
    }
  }

  /// Método especializado para converter CameraImage para InputImage
  InputImage? _convertCameraImageToInputImage(CameraImage cameraImage, InputImageRotation rotation) {
    try {
      final format = InputImageFormatValue.fromRawValue(cameraImage.format.raw);
      if (format == null) {
        print('Formato de imagem desconhecido: ${cameraImage.format.raw}');
        return null;
      }

      // Prepara os bytes de acordo com o formato da imagem
      Uint8List bytes;
      if (cameraImage.planes.length == 1) {
        // Se tiver apenas um plano, usa diretamente
        bytes = cameraImage.planes[0].bytes;
      } else {
        // Para formatos YUV (multplanos), precisamos tratar de forma diferente
        final allBytes = WriteBuffer();
        for (final plane in cameraImage.planes) {
          allBytes.putUint8List(plane.bytes);
        }
        bytes = allBytes.done().buffer.asUint8List();
      }

      // Cria o InputImage com metadados adequados
      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: cameraImage.planes[0].bytesPerRow,
        ),
      );
    } catch (e) {
      print('Erro ao converter imagem: $e');
      return null;
    }
  }

  /// Libera recursos do detector
  void dispose() {
    _faceDetector.close();
  }
}