import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/pet_detail_view_model.dart';
import '../models/pet_info.dart';
import 'edit_pet_view.dart';
import 'pet_gallery_view.dart';

class PetDetailView extends StatelessWidget {
  const PetDetailView({super.key, required this.pet});

  final PetInfo pet;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PetDetailViewModel(pet),
      child: const _PetDetailBody(),
    );
  }
}

class _PetDetailBody extends StatefulWidget {
  const _PetDetailBody();

  @override
  State<_PetDetailBody> createState() => _PetDetailBodyState();
}

class _PetDetailBodyState extends State<_PetDetailBody> {
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PetDetailViewModel>();
    final pet = viewModel.pet;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDog = viewModel.isDog;

    // --- Image Logic ---
    String? petImagePath;
    if (pet.name == 'Milo') {
      petImagePath = 'images/assets/shiba.jpeg';
    } else if (pet.name == 'Luna') {
      petImagePath = 'images/assets/british_sh.jpeg';
    } else if (pet.name == 'Coco') {
      petImagePath = 'images/assets/poodle.jpeg';
    }

    // Pet description placeholder
    const String petDescription =
        'Max is a friendly and lovable Golden Retriever with a heart as golden as his coat. Born on a sunny spring day, Max quickly became the heart of our family with his playful antics and gentle nature.';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Back Button Row ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // Edit button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPetView(pet: pet),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Image Card with Heart ---
              Stack(
                children: [
                  Hero(
                    tag: 'pet_${pet.name}',
                    child: Container(
                      width: double.infinity,
                      height: 320,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8DEF8), // Soft lavender
                        borderRadius: BorderRadius.circular(32),
                        image: petImagePath != null
                            ? DecorationImage(
                                image: AssetImage(petImagePath),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: petImagePath == null
                          ? Center(
                              child: Icon(
                                isDog ? Icons.pets : Icons.pets_outlined,
                                size: 100,
                                color: colorScheme.primary.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- Name and Gender Row ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${pet.species} • ${pet.breed}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Gender icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Icon(
                      Icons.male,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Stats Card (Age | Weight) ---
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EFE6), // Warm beige
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Age',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              pet.age,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.brown.shade200,
                        thickness: 1,
                        width: 32,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Weight',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '3 Kg 500 Gram',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Description ---
              Text(
                petDescription,
                maxLines: _isDescriptionExpanded ? null : 3,
                overflow: _isDescriptionExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.grey.shade700,
                ),
              ),
              GestureDetector(
                onTap: () => setState(
                  () => _isDescriptionExpanded = !_isDescriptionExpanded,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _isDescriptionExpanded ? 'Show less' : 'Read more',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // --- Photo Gallery ---
              if (pet.galleryImages.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Photo Gallery',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PetGalleryView(pet: pet),
                          ),
                        );
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: pet.galleryImages.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage(pet.galleryImages[index]),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // --- Health Overview ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Health Overview',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _InfoTile(
                title: 'Next Vaccination',
                subtitle: '20 March 2026',
                icon: Icons.medical_services,
                iconBgColor: const Color(0xFF7165E3),
                isChecked: false,
              ),
              const SizedBox(height: 12),
              _InfoTile(
                title: 'Notes',
                subtitle: 'Allergies, food preferences...',
                icon: Icons.sticky_note_2,
                iconBgColor: colorScheme.secondary,
                isChecked: false,
              ),

              const SizedBox(height: 40),

              // --- Remove Button ---
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () => viewModel.onConfirmRemovalPressed(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.shade100),
                    backgroundColor: Colors.red.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Remove Pet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Helper: Info Tile ---
class _InfoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBgColor;
  final bool isChecked;

  const _InfoTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBgColor,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          if (isChecked)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF4E1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 16, color: Colors.orange),
            )
          else
            Icon(Icons.chevron_right, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}
