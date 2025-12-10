import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'base_view_model.dart';

class CustomCameraViewModel extends BaseViewModel {
  CustomCameraViewModel() {
    _initCamera();
  }

  CameraController? _controller;
  Future<void>? _initializeFuture;

  CameraController? get controller => _controller;
  Future<void>? get initializeFuture => _initializeFuture;

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final CameraDescription backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(backCamera, ResolutionPreset.medium);
      _initializeFuture = controller.initialize();
      _controller = controller;
      notifyListeners();
    } catch (error) {
      setError('Unable to access camera: $error');
    }
  }

  Future<void> capturePhoto(BuildContext context) async {
    final controller = _controller;
    if (controller == null) {
      return;
    }
    try {
      await _initializeFuture;
      final XFile shot = await controller.takePicture();
      if (!context.mounted) {
        return;
      }
      Navigator.pop(context, File(shot.path));
    } catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to capture photo. Please retry.')),
      );
    }
  }

  void closeCamera(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
