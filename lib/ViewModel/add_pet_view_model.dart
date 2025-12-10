import 'package:flutter/material.dart';

import '../models/pet_info.dart';
import 'base_view_model.dart';

class AddPetViewModel extends BaseViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  final List<String> speciesOptions = const ['Dog', 'Cat', 'Other'];
  String _species = 'Dog';

  String get species => _species;

  void selectSpecies(String value) {
    if (_species == value) {
      return;
    }
    _species = value;
    notifyListeners();
  }

  void savePet(BuildContext context) {
    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final pet = PetInfo(
      name: nameController.text.trim(),
      species: _species,
      breed: breedController.text.trim(),
      age: ageController.text.trim(),
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
