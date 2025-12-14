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

                // 3. Breed
                _buildTextField(
                  context,
                  controller: viewModel.breedController,
                  labelText: 'Breed',
                  icon: Icons.category_outlined,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter the breed (or type)'
                      : null,
                ),
                const SizedBox(height: 20),

                // 4. Age
                _buildTextField(
                  context,
                  controller: viewModel.ageController,
                  labelText: 'Age',
                  hintText: 'e.g. 2 years, 6 months',
                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.text,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter your pet’s age'
                      : null,
                ),

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
                    onPressed: () => viewModel.savePet(context),
                    child: const Text(
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
