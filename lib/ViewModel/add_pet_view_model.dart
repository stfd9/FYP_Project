import 'package:flutter/material.dart';
import 'dart:io'; // Required for File
// In a real app, you would import: import 'package:image_picker/image_picker.dart';
import '../models/pet_info.dart';
import 'base_view_model.dart';

class AddPetViewModel extends BaseViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  final List<String> speciesOptions = const ['Dog', 'Cat'];
  String _species = 'Dog';

  // --- NEW STATE: Holds the selected image file ---
  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  String get species => _species;

  void selectSpecies(String value) {
    if (_species == value) {
      return;
    }
    _species = value;
    notifyListeners();
  }

  // --- NEW METHOD: Handles image selection ---
  Future<void> pickImage(BuildContext context) async {
    // NOTE: You must have the 'image_picker' package installed.
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    // For demonstration, we will use a mocked selection flow:

    // MOCK START: Simulate successful image selection
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker opened (Mocked).')),
    );

    // Assuming the user picked an image.
    // In a real app, replace the following line with the actual image path.
    // For now, we set a temporary file path to show the UI change (this will throw
    // an error unless a file exists at this exact path, but demonstrates the flow):
    // _selectedImage = File('/data/user/0/com.example.yourapp/cache/mock_image.jpg');

    // Since we can't create a real file path here, we'll just toggle a temporary state
    // For actual implementation, replace this with the image_picker logic.

    // MOCK END

    // For UI demonstration, let's just use notifyListeners() to show the tap registers,
    // although without a real file, the image will be blank.
    notifyListeners();
  }

  void savePet(BuildContext context) {
    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    // Include the image path if available. You need to update PetInfo model
    // to accept File/String path if needed.
    final pet = PetInfo(
      name: nameController.text.trim(),
      species: _species,
      breed: breedController.text.trim(),
      age: ageController.text.trim(),
      // imagePath: _selectedImage?.path, // Uncomment if PetInfo supports this
    );

    Navigator.pop(context, pet);
  }

  @override
  void dispose() {
    nameController.dispose();
    breedController.dispose();
    ageController.dispose();
    super.dispose();
  }
}
