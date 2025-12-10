import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/pet_profile_view_model.dart';
import '../models/pet_info.dart';

class PetProfileView extends StatelessWidget {
  const PetProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PetProfileViewModel(),
      child: const _PetProfileBody(),
    );
  }
}

class _PetProfileBody extends StatelessWidget {
  const _PetProfileBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PetProfileViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Pets',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.black87),
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                  onPressed: () => viewModel.openAddPet(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add pet', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your pet profiles for health records and scans.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            if (!viewModel.hasPets)
              _EmptyPetsState(onAddPet: () => viewModel.openAddPet(context))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.pets.length,
                  itemBuilder: (context, index) {
                    final pet = viewModel.pets[index];
                    return _PetCard(
                      pet: pet,
                      onTap: () => viewModel.openPetDetail(context, pet),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  const _PetCard({required this.pet, required this.onTap});

  final PetInfo pet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDog = pet.species.toLowerCase() == 'dog';
    final iconData = isDog ? Icons.pets : Icons.pets_outlined;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          child: Icon(iconData, color: Colors.black87),
        ),
        title: Text(
          pet.name,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${pet.species} • ${pet.breed}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 2),
            Text(
              pet.age,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
      ),
    );
  }
}

class _EmptyPetsState extends StatelessWidget {
  const _EmptyPetsState({required this.onAddPet});

  final VoidCallback onAddPet;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              child: const Icon(
                Icons.pets_outlined,
                size: 32,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No pets yet',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Add your first pet to start tracking their health.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onAddPet,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black87),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add pet',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
