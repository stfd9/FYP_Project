import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'base_view_model.dart';
import '../models/pet_info.dart';

class PetGalleryViewModel extends BaseViewModel {
  final ImagePicker _picker = ImagePicker();
  final List<String> _uploadedImages = [];
  PetInfo? _pet;

  List<String> get uploadedImages => List.unmodifiable(_uploadedImages);
  PetInfo? get pet => _pet;

  List<dynamic> get allImages => [
    if (_pet != null) ..._pet!.galleryImages,
    ..._uploadedImages,
  ];

  void initialize(PetInfo pet) {
    _pet = pet;
    notifyListeners();
  }

  Future<void> pickImage(BuildContext context, ImageSource source) async {
    setLoading(true);
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        _uploadedImages.add(image.path);
        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Photo added successfully!'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      setError('Failed to pick image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setLoading(false);
    }
  }

  void showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Add Photo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 24),
            _buildSourceOption(
              context: ctx,
              icon: Icons.photo_library_outlined,
              label: 'Choose from Gallery',
              color: const Color(0xFF7165E3),
              onTap: () {
                Navigator.pop(ctx);
                pickImage(context, ImageSource.gallery);
              },
            ),
            const SizedBox(height: 12),
            _buildSourceOption(
              context: ctx,
              icon: Icons.camera_alt_outlined,
              label: 'Take a Photo',
              color: const Color(0xFFFF9F59),
              onTap: () {
                Navigator.pop(ctx);
                pickImage(context, ImageSource.camera);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteImage(BuildContext context, int index, bool isAssetImage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Photo'),
          ],
        ),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (!isAssetImage) {
                final uploadedIndex = index - (_pet?.galleryImages.length ?? 0);
                if (uploadedIndex >= 0 &&
                    uploadedIndex < _uploadedImages.length) {
                  _uploadedImages.removeAt(uploadedIndex);
                  notifyListeners();
                }
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Photo deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void viewFullImage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            _FullImageView(images: allImages, initialIndex: index),
      ),
    );
  }
}

class _FullImageView extends StatelessWidget {
  final List<dynamic> images;
  final int initialIndex;

  const _FullImageView({required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        itemCount: images.length,
        controller: PageController(initialPage: initialIndex),
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer(
              child: Image.asset(images[index], fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }
}
