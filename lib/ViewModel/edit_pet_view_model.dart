import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/breed_option.dart';
import '../models/pet_info.dart';

class EditPetViewModel extends ChangeNotifier {
  EditPetViewModel(this._pet) {
    _initializeControllers();
  }

  final PetInfo _pet;
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController nameController;
  late final TextEditingController speciesController;
  late final TextEditingController breedController;
  late final TextEditingController ageController;
  late final TextEditingController weightController;
  late final TextEditingController colourController;
  late final TextEditingController descriptionController;

  File? _profilePhotoFile;
  String? _selectedGalleryUrl;

  String _selectedGender = 'Male';
  bool _hasChanges = false;
  BreedOption? _selectedBreed;
  List<BreedOption> _breeds = _dogBreeds;

  bool get hasChanges => _hasChanges;
  PetInfo get pet => _pet;
  String get gender => _selectedGender;
  String get species => speciesController.text;
  File? get profilePhotoFile => _profilePhotoFile;
  String? get selectedGalleryUrl => _selectedGalleryUrl;
  BreedOption? get selectedBreed => _selectedBreed;
  List<BreedOption> get breeds => List.unmodifiable(_breeds);

  void _initializeControllers() {
    nameController = TextEditingController(text: _pet.name);
    speciesController = TextEditingController(text: _pet.species);
    breedController = TextEditingController(text: _pet.breed);
    ageController = TextEditingController(text: _pet.age);
    weightController = TextEditingController(text: _pet.weight ?? '');
    colourController = TextEditingController(text: _pet.colour ?? '');
    descriptionController = TextEditingController();

    _selectedGender = _pet.gender ?? _selectedGender;
    _breeds = _pet.species.toLowerCase() == 'cat' ? _catBreeds : _dogBreeds;
    _selectedBreed = _breeds.firstWhere(
      (breed) => breed.name == _pet.breed,
      orElse: () => _breeds.first,
    );

    nameController.addListener(_onFieldChanged);
    speciesController.addListener(_onFieldChanged);
    breedController.addListener(_onFieldChanged);
    ageController.addListener(_onFieldChanged);
    weightController.addListener(_onFieldChanged);
    colourController.addListener(_onFieldChanged);
    descriptionController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final hasNameChanged = nameController.text != _pet.name;
    final hasSpeciesChanged = speciesController.text != _pet.species;
    final hasBreedChanged = breedController.text != _pet.breed;
    final hasAgeChanged = ageController.text != _pet.age;
    final hasWeightChanged = weightController.text != (_pet.weight ?? '');
    final hasColourChanged = colourController.text != (_pet.colour ?? '');

    final newHasChanges =
        hasNameChanged ||
        hasSpeciesChanged ||
        hasBreedChanged ||
        hasAgeChanged ||
        hasWeightChanged ||
        hasColourChanged;

    if (newHasChanges != _hasChanges) {
      _hasChanges = newHasChanges;
      notifyListeners();
    }
  }

  void setGender(String gender) {
    if (_selectedGender == gender) {
      return;
    }
    _selectedGender = gender;
    _hasChanges = true;
    notifyListeners();
  }

  void setSelectedBreed(BreedOption? value) {
    if (_selectedBreed == value || value == null) {
      return;
    }
    _selectedBreed = value;
    breedController.text = value.name;
    _hasChanges = true;
    notifyListeners();
  }

  Future<void> pickProfilePhotoFromCamera() async {
    await _pickProfilePhoto(ImageSource.camera);
  }

  Future<void> pickProfilePhotoFromLocal() async {
    await _pickProfilePhoto(ImageSource.gallery);
  }

  Future<void> _pickProfilePhoto(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (pickedFile == null) {
      return;
    }
    _profilePhotoFile = File(pickedFile.path);
    _selectedGalleryUrl = null;
    _hasChanges = true;
    notifyListeners();
  }

  void setProfilePhotoFromGallery(String url) {
    _selectedGalleryUrl = url;
    _profilePhotoFile = null;
    _hasChanges = true;
    notifyListeners();
  }

  void saveChanges(BuildContext context) {
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
    colourController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

const List<BreedOption> _dogBreeds = [
  BreedOption(id: 'dog_shiba', name: 'Shiba Inu'),
  BreedOption(id: 'dog_golden', name: 'Golden Retriever'),
  BreedOption(id: 'dog_poodle', name: 'Poodle'),
  BreedOption(id: 'dog_beagle', name: 'Beagle'),
];

const List<BreedOption> _catBreeds = [
  BreedOption(id: 'cat_bsh', name: 'British Shorthair'),
  BreedOption(id: 'cat_persian', name: 'Persian'),
  BreedOption(id: 'cat_siamese', name: 'Siamese'),
  BreedOption(id: 'cat_maine', name: 'Maine Coon'),
];
