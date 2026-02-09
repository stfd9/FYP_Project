import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pet_info.dart';
import '../ViewModel/pet_gallery_view_model.dart';

class PetGalleryView extends StatelessWidget {
  final PetInfo pet;
  final bool selectionMode;

  const PetGalleryView({
    super.key,
    required this.pet,
    this.selectionMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PetGalleryViewModel()..initialize(pet),
      child: _PetGalleryBody(selectionMode: selectionMode),
    );
  }
}

class _PetGalleryBody extends StatelessWidget {
  const _PetGalleryBody({required this.selectionMode});

  final bool selectionMode;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PetGalleryViewModel>();
    final pet = viewModel.pet!;
    final allImages = viewModel.allImages;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
          ),
          onPressed: () => viewModel.onBackPressed(context),
        ),
        title: Text(
          selectionMode ? 'Select Photo' : '${pet.name}\'s Gallery',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        centerTitle: true,
        actions: selectionMode
            ? null
            : [
                IconButton(
                  onPressed: () => viewModel.showImageSourceDialog(context),
                  icon: const Icon(
                    Icons.add_photo_alternate,
                    color: Color(0xFF2D3142),
                  ),
                ),
                if (viewModel.hasPendingUploads)
                  IconButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () => viewModel.confirmUpload(context),
                    icon: Icon(
                      Icons.check_circle,
                      color: viewModel.isLoading
                          ? Colors.grey.shade400
                          : const Color(0xFF2D3142),
                    ),
                  ),
                const SizedBox(width: 8),
              ],
      ),
      body: allImages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 100,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No photos yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add photos',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: allImages.length,
                itemBuilder: (context, index) {
                  final imagePath = allImages[index];
                  final isAsset = pet.galleryImages.contains(imagePath);
                  final isNetwork =
                      imagePath is String && imagePath.startsWith('http');

                  return GestureDetector(
                    onTap: () {
                      if (selectionMode) {
                        if (isNetwork) {
                          Navigator.pop(context, imagePath);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Select a gallery photo only.'),
                            ),
                          );
                        }
                        return;
                      }

                      viewModel.onImageTapped(index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _FullScreenImageView(
                            imagePath: imagePath,
                            heroTag: 'gallery_${pet.name}_$index',
                            isAsset: isAsset,
                            isNetwork: isNetwork,
                            onDelete: () => viewModel.deleteImage(
                              context: context,
                              imagePath: imagePath,
                              isAssetImage: isAsset,
                              isNetworkImage: isNetwork,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'gallery_${pet.name}_$index',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: isNetwork
                              ? Image.network(imagePath, fit: BoxFit.cover)
                              : isAsset
                              ? Image.asset(imagePath, fit: BoxFit.cover)
                              : Image.file(File(imagePath), fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

// --- Full Screen Image View ---
class _FullScreenImageView extends StatelessWidget {
  final dynamic imagePath;
  final String heroTag;
  final bool isAsset;
  final bool isNetwork;
  final VoidCallback onDelete;

  const _FullScreenImageView({
    required this.imagePath,
    required this.heroTag,
    required this.isAsset,
    required this.isNetwork,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: isNetwork
                ? Image.network(imagePath, fit: BoxFit.contain)
                : isAsset
                ? Image.asset(imagePath, fit: BoxFit.contain)
                : Image.file(File(imagePath), fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
