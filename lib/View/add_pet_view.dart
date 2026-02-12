import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Required for FileImage (though functionality is mocked)

import '../ViewModel/add_pet_view_model.dart';

class AddPetView extends StatelessWidget {
  const AddPetView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddPetViewModel(),
      child: const _AddPetBody(),
    );
  }
}

class _AddPetBody extends StatelessWidget {
  const _AddPetBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddPetViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine the width for the square-like image area
    final double padding = 24.0;
    final double cardWidth = MediaQuery.of(context).size.width - (padding * 2);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // App Theme Background
      appBar: AppBar(
        title: const Text(
          'Add a New Pet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. FULL-WIDTH, RECTANGULAR/SQUARE IMAGE PICKER ---
                Center(
                  child: GestureDetector(
                    onTap: () => viewModel.pickImage(context),
                    child: Container(
                      // Width is full screen minus padding
                      width: cardWidth,
                      // Aspect ratio for a square/near-square look
                      height: cardWidth * 0.75,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          24,
                        ), // Consistent large radius
                        border: Border.all(
                          color: viewModel.selectedImage != null
                              ? colorScheme.primary
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                          ),
                        ],
                        // Display selected image if available
                        image: viewModel.selectedImage != null
                            ? DecorationImage(
                                image: FileImage(viewModel.selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: viewModel.selectedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to Add Photo',
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // --- 2. Pet Information Card Content ---
                const Text(
                  'Pet information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // 1. Pet Name
                _buildTextField(
                  context,
                  controller: viewModel.nameController,
                  labelText: 'Pet name',
                  icon: Icons.badge_outlined,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter your pet’s name'
                      : null,
                ),
                const SizedBox(height: 20),

                // 2. Species Dropdown (Styled as a full-width input)
                _buildDropdownField(
                  context,
                  labelText: 'Species',
                  icon: Icons.pets_outlined,
                  value: viewModel.species,
                  options: viewModel.speciesOptions,
                  onChanged: viewModel.selectSpecies,
                ),

                const SizedBox(height: 20),

                // 3. Gender
                _buildDropdownField(
                  context,
                  labelText: 'Gender',
                  icon: Icons.wc_outlined,
                  value: viewModel.gender,
                  options: viewModel.genderOptions,
                  onChanged: viewModel.selectGender,
                ),

                const SizedBox(height: 20),

                // 4. Breed (from Firestore)
                _buildBreedDropdown(context, viewModel: viewModel),

                const SizedBox(height: 20),

                // 5. Colour
                _buildTextField(
                  context,
                  controller: viewModel.colourController,
                  labelText: 'Colour',
                  icon: Icons.palette_outlined,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter your pet’s colour'
                      : null,
                ),

                const SizedBox(height: 20),

                // 6. Weight
                _buildTextField(
                  context,
                  controller: viewModel.weightController,
                  labelText: 'Weight (kg)',
                  icon: Icons.monitor_weight_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed = double.tryParse(value?.trim() ?? '');
                    if (parsed == null || parsed <= 0) {
                      return 'Please enter a valid weight';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // 7. Date of Birth
                _buildDateField(context, viewModel: viewModel),

                const SizedBox(height: 20),

                // 8. Gallery Photos
                _buildGalleryPicker(context, viewModel: viewModel),

                const SizedBox(height: 40),

                // --- Save Button ---
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary, // Cobalt Blue
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: colorScheme.primary.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: viewModel.isLoading
                        ? null
                        : () => viewModel.savePet(context),
                    child: viewModel.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Save Pet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper for structured TextFormField
  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
          decoration: _inputDecoration(
            context,
            icon: icon,
            hintText: hintText,
            labelText: labelText,
          ),
          validator: validator,
        ),
      ],
    );
  }

  // Helper for structured DropdownField
  Widget _buildDropdownField(
    BuildContext context, {
    required String labelText,
    required IconData icon,
    required String value,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: _inputDecoration(
            context,
            icon: icon,
            hintText: labelText,
            isDropdown: true,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
              items: options
                  .map(
                    (option) =>
                        DropdownMenuItem(value: option, child: Text(option)),
                  )
                  .toList(),
              onChanged: (newValue) => onChanged(newValue!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBreedDropdown(
    BuildContext context, {
    required AddPetViewModel viewModel,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final breeds = viewModel.filteredBreeds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Breed',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<BreedOption>(
          initialValue: viewModel.selectedBreed,
          decoration: _inputDecoration(
            context,
            icon: Icons.category_outlined,
            hintText: viewModel.isBreedsLoading
                ? 'Loading breeds...'
                : 'Select breed',
            isDropdown: true,
          ),
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
          items: breeds
              .map(
                (breed) =>
                    DropdownMenuItem(value: breed, child: Text(breed.name)),
              )
              .toList(),
          onChanged: viewModel.isBreedsLoading
              ? null
              : (value) => viewModel.selectBreed(value),
          validator: (value) {
            if (value == null) {
              return 'Please select a breed';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required AddPetViewModel viewModel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: viewModel.dateOfBirthController,
          readOnly: true,
          onTap: () => viewModel.pickDateOfBirth(context),
          decoration: _inputDecoration(
            context,
            icon: Icons.cake_outlined,
            hintText: 'Select date of birth',
            labelText: 'Date of Birth',
          ),
          validator: (value) => value == null || value.trim().isEmpty
              ? 'Please select date of birth'
              : null,
        ),
      ],
    );
  }

  Widget _buildGalleryPicker(
    BuildContext context, {
    required AddPetViewModel viewModel,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gallery photos',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => viewModel.pickGalleryImages(context),
          icon: Icon(Icons.photo_library_outlined, color: colorScheme.primary),
          label: Text(
            viewModel.galleryImages.isEmpty
                ? 'Add gallery photos'
                : 'Selected ${viewModel.galleryImages.length} photos',
          ),
        ),
        if (viewModel.galleryImages.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.galleryImages.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    viewModel.galleryImages[index],
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  // Helper for InputDecoration styling
  InputDecoration _inputDecoration(
    BuildContext context, {
    required IconData icon,
    String? hintText,
    String? labelText,
    bool isDropdown = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: isDropdown
          ? null
          : Icon(icon, color: Colors.grey.shade400, size: 22),
      filled: true,
      fillColor: const Color(0xFFF8F9FD),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
    );
  }
}
