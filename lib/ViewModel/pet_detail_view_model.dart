import 'package:flutter/material.dart';

import '../models/pet_info.dart';
import 'base_view_model.dart';

class PetDetailViewModel extends BaseViewModel {
  PetDetailViewModel(this.pet);

  final PetInfo pet;

  bool get isDog => pet.species.toLowerCase() == 'dog';

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
