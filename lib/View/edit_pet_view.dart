import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/edit_pet_view_model.dart';
import '../models/pet_info.dart';
import '../View/pet_gallery_view.dart';
import '../models/breed_option.dart';

class EditPetView extends StatelessWidget {
  const EditPetView({super.key, required this.pet});

  final PetInfo pet;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditPetViewModel(pet),
      child: const _EditPetBody(),
    );
  }
}

class _EditPetBody extends StatelessWidget {
  const _EditPetBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditPetViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Pet Details',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: viewModel.hasChanges
                ? () => viewModel.saveChanges(context)
                : null,
            child: Text(
              'Save',
              style: TextStyle(
                color: viewModel.hasChanges
                    ? colorScheme.primary
                    : Colors.grey.shade400,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Profile Image Section ---
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8DEF8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        width: 3,
                      ),
                      image: viewModel.profilePhotoFile != null
                          ? DecorationImage(
                              image: FileImage(viewModel.profilePhotoFile!),
                              fit: BoxFit.cover,
                            )
                          : (viewModel.selectedGalleryUrl != null &&
                                viewModel.selectedGalleryUrl!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(
                                viewModel.selectedGalleryUrl!,
                              ),
                              fit: BoxFit.cover,
                            )
                          : (viewModel.pet.photoUrl != null &&
                                viewModel.pet.photoUrl!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(viewModel.pet.photoUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child:
                        viewModel.profilePhotoFile == null &&
                            (viewModel.selectedGalleryUrl == null ||
                                viewModel.selectedGalleryUrl!.isEmpty) &&
                            (viewModel.pet.photoUrl == null ||
                                viewModel.pet.photoUrl!.isEmpty)
                        ? Icon(Icons.pets, size: 50, color: colorScheme.primary)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _showPhotoOptions(context, viewModel),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- Form Fields ---
            _buildTextField(
              label: 'Pet Name',
              controller: viewModel.nameController,
              icon: Icons.pets,
            ),
            const SizedBox(height: 20),

            _buildReadOnlyField(
              label: 'Species',
              value: viewModel.species,
              icon: Icons.category,
            ),
            const SizedBox(height: 20),

            _buildBreedDropdown(context, viewModel: viewModel),
            const SizedBox(height: 20),

            _buildTextField(
              label: 'Colour',
              controller: viewModel.colourController,
              icon: Icons.palette_outlined,
            ),
            const SizedBox(height: 20),

            _buildTextField(
              label: 'Weight',
              controller: viewModel.weightController,
              icon: Icons.monitor_weight_outlined,
              suffix: 'kg',
            ),
            const SizedBox(height: 20),

            _buildReadOnlyField(
              label: 'Gender',
              value: viewModel.gender,
              icon: Icons.wc_outlined,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showPhotoOptions(BuildContext context, EditPetViewModel viewModel) {
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
              'Update Photo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 24),
            _buildActionOption(
              context: ctx,
              icon: Icons.camera_alt_outlined,
              label: 'Take a Photo',
              color: const Color(0xFFFF9F59),
              onTap: () {
                Navigator.pop(ctx);
                viewModel.pickProfilePhotoFromCamera();
              },
            ),
            const SizedBox(height: 12),
            _buildActionOption(
              context: ctx,
              icon: Icons.photo_library_outlined,
              label: 'Choose from Local Gallery',
              color: const Color(0xFF7165E3),
              onTap: () {
                Navigator.pop(ctx);
                viewModel.pickProfilePhotoFromLocal();
              },
            ),
            const SizedBox(height: 12),
            _buildActionOption(
              context: ctx,
              icon: Icons.collections_outlined,
              label: 'Choose from Pet Gallery',
              color: const Color(0xFF4CAF50),
              onTap: () async {
                Navigator.pop(ctx);
                final selectedUrl = await Navigator.push<String?>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PetGalleryView(pet: viewModel.pet, selectionMode: true),
                  ),
                );
                if (selectedUrl != null && selectedUrl.isNotEmpty) {
                  viewModel.setProfilePhotoFromGallery(selectedUrl);
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActionOption({
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
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
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

  Widget _buildBreedDropdown(
    BuildContext context, {
    required EditPetViewModel viewModel,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Breed',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<BreedOption>(
          initialValue: viewModel.selectedBreed,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.info_outline,
              color: Colors.grey.shade500,
              size: 22,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
          icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
          items: viewModel.breeds
              .map(
                (breed) =>
                    DropdownMenuItem(value: breed, child: Text(breed.name)),
              )
              .toList(),
          onChanged: viewModel.setSelectedBreed,
        ),
      ],
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          enabled: false,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 22),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 22),
            suffixText: suffix,
            suffixStyle: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF7165E3), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Gender Option Widget ---
