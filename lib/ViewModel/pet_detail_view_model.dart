import 'package:flutter/material.dart';

import '../models/pet_info.dart';
import '../View/edit_pet_view.dart';
import '../View/pet_gallery_view.dart';
import 'base_view_model.dart';

class PetDetailViewModel extends BaseViewModel {
  PetDetailViewModel(this.pet);

  final PetInfo pet;

  bool get isDog => pet.species.toLowerCase() == 'dog';

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
}
