import 'package:flutter/material.dart';

import '../View/add_pet_view.dart';
import '../View/pet_detail_view.dart';
import '../models/pet_info.dart';
import 'base_view_model.dart';

class PetProfileViewModel extends BaseViewModel {
  final List<PetInfo> _pets = [
    const PetInfo(
      name: 'Milo',
      species: 'Dog',
      breed: 'Shiba Inu',
      age: '2 years',
    ),
    const PetInfo(
      name: 'Luna',
      species: 'Cat',
      breed: 'British Shorthair',
      age: '3 years',
    ),
    const PetInfo(name: 'Coco', species: 'Dog', breed: 'Poodle', age: '1 year'),
  ];

  List<PetInfo> get pets => List.unmodifiable(_pets);

  bool get hasPets => _pets.isNotEmpty;

  Future<void> openAddPet(BuildContext context) async {
    final newPet = await Navigator.push<PetInfo?>(
      context,
      MaterialPageRoute(builder: (_) => const AddPetView()),
    );

    if (newPet == null) {
      return;
    }

    _pets.add(newPet);
    notifyListeners();
    if (!context.mounted) {
      return;
    }
    _showSnack(context, '${newPet.name} added successfully.');
  }

  Future<void> openPetDetail(BuildContext context, PetInfo pet) async {
    final removed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PetDetailView(pet: pet)),
    );

    if (removed == true) {
      _pets.remove(pet);
      notifyListeners();
      if (!context.mounted) {
        return;
      }
      _showSnack(context, '${pet.name} has been removed.');
    }
  }

  void _showSnack(BuildContext context, String message) {
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
