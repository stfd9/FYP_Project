import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/edit_pet_view_model.dart';
import '../models/pet_info.dart';

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
                    ),
                    child: Icon(
                      Icons.pets,
                      size: 50,
                      color: colorScheme.primary,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
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

            _buildTextField(
              label: 'Species',
              controller: viewModel.speciesController,
              icon: Icons.category,
            ),
            const SizedBox(height: 20),

            _buildTextField(
              label: 'Breed',
              controller: viewModel.breedController,
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 20),

            _buildTextField(
              label: 'Age',
              controller: viewModel.ageController,
              icon: Icons.cake,
            ),
            const SizedBox(height: 20),

            _buildTextField(
              label: 'Weight',
              controller: viewModel.weightController,
              icon: Icons.monitor_weight_outlined,
              suffix: 'kg',
            ),
            const SizedBox(height: 20),

            // --- Gender Selection ---
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _GenderOption(
                    label: 'Male',
                    icon: Icons.male,
                    isSelected: viewModel.selectedGender == 'Male',
                    onTap: () => viewModel.setGender('Male'),
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _GenderOption(
                    label: 'Female',
                    icon: Icons.female,
                    isSelected: viewModel.selectedGender == 'Female',
                    onTap: () => viewModel.setGender('Female'),
                    color: const Color(0xFFE91E63),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- Description ---
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: viewModel.descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tell us about your pet...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
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
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
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
class _GenderOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _GenderOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey.shade500,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
