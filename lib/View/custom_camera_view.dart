import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/custom_camera_view_model.dart';

class CustomCameraView extends StatelessWidget {
  const CustomCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomCameraViewModel(),
      child: const _CustomCameraBody(),
    );
  }
}

class _CustomCameraBody extends StatelessWidget {
  const _CustomCameraBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CustomCameraViewModel>();
    final controller = viewModel.controller;

    return Scaffold(
      backgroundColor: Colors.black,
      body: controller == null
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : FutureBuilder(
              future: viewModel.initializeFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                return Stack(
                  children: [
                    Center(child: CameraPreview(controller)),
                    SafeArea(
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => viewModel.closeCamera(context),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: GestureDetector(
                          onTap: () => viewModel.capturePhoto(context),
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: Center(
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
