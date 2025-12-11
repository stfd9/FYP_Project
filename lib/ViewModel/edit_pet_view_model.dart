import 'package:flutter/material.dart';

import '../models/pet_info.dart';

class EditPetViewModel extends ChangeNotifier {
  EditPetViewModel(this._pet) {
    _initializeControllers();
  }

  final PetInfo _pet;

  late final TextEditingController nameController;
  late final TextEditingController speciesController;
  late final TextEditingController breedController;
  late final TextEditingController ageController;
  late final TextEditingController weightController;
  late final TextEditingController descriptionController;

  String _selectedGender = 'Male';
  bool _hasChanges = false;

  String get selectedGender => _selectedGender;
  bool get hasChanges => _hasChanges;
  PetInfo get pet => _pet;

  void _initializeControllers() {
    nameController = TextEditingController(text: _pet.name);
    speciesController = TextEditingController(text: _pet.species);
    breedController = TextEditingController(text: _pet.breed);
    ageController = TextEditingController(text: _pet.age);
    weightController = TextEditingController(text: '3.5'); // Default weight
    descriptionController = TextEditingController();

    // Add listeners to track changes
    nameController.addListener(_onFieldChanged);
    speciesController.addListener(_onFieldChanged);
    breedController.addListener(_onFieldChanged);
    ageController.addListener(_onFieldChanged);
    weightController.addListener(_onFieldChanged);
    descriptionController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final hasNameChanged = nameController.text != _pet.name;
    final hasSpeciesChanged = speciesController.text != _pet.species;
    final hasBreedChanged = breedController.text != _pet.breed;
    final hasAgeChanged = ageController.text != _pet.age;

    final newHasChanges =
        hasNameChanged || hasSpeciesChanged || hasBreedChanged || hasAgeChanged;

    if (newHasChanges != _hasChanges) {
      _hasChanges = newHasChanges;
      notifyListeners();
    }
  }

  void setGender(String gender) {
    if (_selectedGender != gender) {
      _selectedGender = gender;
      _hasChanges = true;
      notifyListeners();
    }
  }

  void saveChanges(BuildContext context) {
    // TODO: Implement actual save logic with backend/database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pet details updated successfully!'),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    speciesController.dispose();
    breedController.dispose();
    ageController.dispose();
    weightController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
