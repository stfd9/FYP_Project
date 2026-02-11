import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pet_info.dart';
import '../View/edit_pet_view.dart';
import '../View/pet_gallery_view.dart';
import 'base_view_model.dart';

class PetDetailViewModel extends BaseViewModel {
  PetDetailViewModel(PetInfo pet) : _pet = pet;

  PetInfo _pet;
  PetInfo get pet => _pet;

  bool get isDog => _pet.species.toLowerCase() == 'dog';

  Future<void> refreshPet() async {
    final petId = _pet.id;
    if (petId == null || petId.isEmpty) return;

    setLoading(true);
    setError(null);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('pet')
          .doc(petId)
          .get();
      if (!snapshot.exists) return;

      final data = snapshot.data();
      if (data == null) return;

      final dobValue = data['dateOfBirth'];
      final DateTime? dateOfBirth = dobValue is Timestamp
          ? dobValue.toDate()
          : null;
      final breedId = data['breedId'] as String?;
      String breedName = _pet.breed;
      if (breedId != null && breedId.isNotEmpty) {
        final breedDoc = await FirebaseFirestore.instance
            .collection('breed')
            .doc(breedId)
            .get();
        if (breedDoc.exists) {
          final breedData = breedDoc.data();
          final name = breedData?['breedName'] as String?;
          if (name != null && name.isNotEmpty) {
            breedName = name;
          }
        }
      }

      final photoUrls = (data['photoUrls'] as List<dynamic>? ?? [])
          .whereType<String>()
          .toList();
      final weightValue = data['weightKg'];
      final double? weightKg = weightValue is num
          ? weightValue.toDouble()
          : null;

      _pet = PetInfo(
        id: data['petId'] as String? ?? petId,
        name: (data['petName'] as String?) ?? _pet.name,
        species: (data['species'] as String?) ?? _pet.species,
        gender: data['gender'] as String?,
        colour: data['colour'] as String?,
        dateOfBirth: dateOfBirth,
        breed: breedName,
        breedId: breedId,
        userId: data['userId'] as String?,
        photoUrl: data['photoUrl'] as String?,
        photoUrls: photoUrls,
        weightKg: weightKg,
        age: dateOfBirth != null ? _formatAge(dateOfBirth) : _pet.age,
        galleryImages: _pet.galleryImages,
      );
      notifyListeners();
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading(false);
    }
  }

  void onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void onEditPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPetView(pet: pet)),
    );
  }

  void onViewGalleryPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetGalleryView(pet: pet)),
    );
  }

  void onConfirmRemovalPressed(BuildContext context) {
    confirmRemoval(context);
  }

  Future<void> confirmRemoval(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove pet'),
        content: Text('Are you sure you want to remove ${pet.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) {
        return;
      }
      Navigator.pop(context, true);
    }
  }

  String _formatAge(DateTime dob) {
    final now = DateTime.now();
    int years = now.year - dob.year;
    int months = now.month - dob.month;
    if (now.day < dob.day) {
      months -= 1;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }
    if (years <= 0) {
      return '$months months';
    }
    if (months == 0) {
      return '$years years';
    }
    return '$years years $months months';
  }
}
