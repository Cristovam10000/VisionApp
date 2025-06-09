// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:vision_app/core/constants/app_colors.dart';
import 'package:vision_app/presentation/controllers/face_camera_controller_setup.dart';
import 'package:vision_app/presentation/pages/camera/face_overlay.dart';
import 'package:vision_app/presentation/controllers/face_utils.dart';
import 'dart:io';
import '../../../core/services/upload_service.dart';
import '../../controllers/face_camera_utils.dart';

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

  bool _isFaceWellPositioned = false;

  // Variável para controlar manualmente o modo do flash
  CameraFlashMode _currentFlashMode = CameraFlashMode.off;

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


  void _toggleFlashMode() {
    setState(() {
      _currentFlashMode = toggleFlashMode(
        currentFlashMode: _currentFlashMode,
        controller: _controller,
      );
    });
  }



  Future<void> _handleConfirmUpload() async {
    await handleConfirmUpload(
      context: context,
      capturedImage: _capturedImage,
      isProcessing: _isProcessing,
      isFaceWellPositioned: _isFaceWellPositioned,
      setProcessing: (processing) => setState(() => _isProcessing = processing),
      controller: _controller,
      perfil: widget.perfil,
      uploadService: _uploadService,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _capturedImage == null
              ? AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
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
                          await _controller.startImageStream();
                          setState(() => _capturedImage = null);
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
            Stack(
              fit: StackFit.expand,
              children: [
                SmartFaceCamera(
                  controller: _controller,
                  indicatorShape: IndicatorShape.none,
                  showControls: false,
                  showCameraLensControl: false,
                ),
                Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
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
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color.fromRGBO(3, 77, 162, 1),
                          foregroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(
                              _currentFlashMode == CameraFlashMode.always
                                  ? Icons.flash_on
                                  : _currentFlashMode == CameraFlashMode.off
                                      ? Icons.flash_off
                                      : Icons.flash_auto,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed:
                            _controller.enableControls
                                ? _toggleFlashMode
                                : null,
                      ),
                    ],
                  ),
                ),
              ],
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
