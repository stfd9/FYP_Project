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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Light grey background
      body: SafeArea(
        child: Stack(
          children: [
            // --- Main Content ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Pets',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${viewModel.pets.length} pets registered',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- Grid Content ---
                  if (!viewModel.hasPets)
                    _EmptyPetsState(
                      onAddPet: () => viewModel.openAddPet(context),
                    )
                  else
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 Columns
                              childAspectRatio: 0.75, // Taller cards
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: viewModel.pets.length,
                        itemBuilder: (context, index) {
                          final pet = viewModel.pets[index];

                          return _PetGridCard(
                            pet: pet,
                            onTap: () => viewModel.openPetDetail(context, pet),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            // --- Floating Add Button (Bottom Right) ---
            Positioned(
              bottom: 30,
              right: 24,
              child: _FloatingAddButton(
                onTap: () => viewModel.openAddPet(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 1. Fixed Floating Add Button ---
class _FloatingAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _FloatingAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 64,
      height: 64,
      child: FloatingActionButton(
        onPressed: onTap,
        backgroundColor: colorScheme.primary, // Cobalt Blue
        elevation: 6,
        shape: const CircleBorder(),
        child: Center(
          child: Image.asset(
            'images/assets/dog_icon.png', // Ensure this file exists
            width: 38,
            height: 38,
            color: Colors.white,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

// --- 2. REDESIGNED Grid Card (Two-Tone: Color Top, White Bottom) ---
class _PetGridCard extends StatelessWidget {
  final PetInfo pet;
  final VoidCallback onTap;

  const _PetGridCard({required this.pet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDog = pet.species.toLowerCase() == 'dog';

    // --- Image Logic ---
    String? petImagePath;
    if (pet.name == 'Milo') {
      petImagePath = 'images/assets/shiba.png';
    } else if (pet.name == 'Luna') {
      petImagePath = 'images/assets/british_sh.png';
    } else if (pet.name == 'Coco') {
      petImagePath = 'images/assets/poodle.png';
    }

    // --- Color Logic ---
    final topBackgroundColor = isDog
        ? const Color(0xFFE3F2FD) // Soft Blue for Dogs
        : const Color(0xFFF3E5F5); // Soft Pink for Cats

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // The main card background is WHITE
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // --- Top Half: Image (Colored Background) ---
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: topBackgroundColor, // Color applied here
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    // No bottom radius so it sits flush with the white part
                  ),
                ),
                child: Center(
                  child: petImagePath != null
                      ? Image.asset(
                          petImagePath,
                          width: 110,
                          height: 110,
                          fit: BoxFit.contain,
                        )
                      : Icon(
                          isDog ? Icons.pets : Icons.pets_outlined,
                          size: 50,
                          color: Colors.black.withValues(alpha: 0.1),
                        ),
                ),
              ),
            ),

            // --- Bottom Half: Details (White Background) ---
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pet.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87, // Black Text
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pet.breed,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600, // Grey Text
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      pet.age,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade800, // Dark Grey Text
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 3. Empty State ---
class _EmptyPetsState extends StatelessWidget {
  final VoidCallback onAddPet;
  const _EmptyPetsState({required this.onAddPet});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 70, color: Colors.grey.shade300),
            const SizedBox(height: 20),
            Text(
              'No pets yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first pet to start tracking.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
