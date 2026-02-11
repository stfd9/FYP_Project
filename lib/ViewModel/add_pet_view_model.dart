import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/breed_option.dart';
import '../models/pet_info.dart';
import 'base_view_model.dart';

class AddPetViewModel extends BaseViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController colourController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  final List<String> speciesOptions = const ['Dog', 'Cat'];
  final List<String> genderOptions = const ['Male', 'Female'];

  final ImagePicker _picker = ImagePicker();

  String _species = 'Dog';
  String _gender = 'Male';

  File? _selectedImage;
  final List<File> _galleryImages = [];

  bool _isBreedsLoading = false;
  BreedOption? _selectedBreed;
  List<BreedOption> _breeds = _dogBreeds;

  String get species => _species;
  String get gender => _gender;
  File? get selectedImage => _selectedImage;
  List<File> get galleryImages => List.unmodifiable(_galleryImages);
  bool get isBreedsLoading => _isBreedsLoading;
  BreedOption? get selectedBreed => _selectedBreed;
  List<BreedOption> get filteredBreeds => List.unmodifiable(_breeds);

  void selectSpecies(String value) {
    if (_species == value) {
      return;
    }
    _species = value;
    _breeds = _species == 'Dog' ? _dogBreeds : _catBreeds;
    _selectedBreed = null;
    notifyListeners();
  }

  void selectGender(String value) {
    if (_gender == value) {
      return;
    }
    _gender = value;
    notifyListeners();
  }

  void selectBreed(BreedOption? value) {
    if (_selectedBreed == value) {
      return;
    }
    _selectedBreed = value;
    notifyListeners();
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (pickedFile == null) {
        return;
      }
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<void> pickGalleryImages(BuildContext context) async {
    try {
      final List<XFile> files = await _picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (files.isEmpty) {
        return;
      }
      _galleryImages
        ..clear()
        ..addAll(files.map((file) => File(file.path)));
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick gallery images: $e')),
      );
    }
  }

  Future<void> pickDateOfBirth(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 1),
      firstDate: DateTime(now.year - 30),
      lastDate: now,
    );
    if (date == null) {
      return;
    }
    dateOfBirthController.text =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void savePet(BuildContext context) {
    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final pet = PetInfo(
      name: nameController.text.trim(),
      species: _species,
      breed: _selectedBreed?.name ?? breedController.text.trim(),
      age: ageController.text.trim(),
      gender: _gender,
      colour: colourController.text.trim(),
      weight: weightController.text.trim(),
      dateOfBirth: dateOfBirthController.text.trim(),
      galleryImages: _galleryImages.map((file) => file.path).toList(),
    );

    Navigator.pop(context, pet);
  }

  @override
  void dispose() {
    nameController.dispose();
    breedController.dispose();
    ageController.dispose();
    colourController.dispose();
    weightController.dispose();
    dateOfBirthController.dispose();
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
