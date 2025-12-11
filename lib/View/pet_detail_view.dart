import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/pet_detail_view_model.dart';
import '../models/pet_info.dart';
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
  double _sheetExtent = 0.55; // Tracks sheet expansion for parallax

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

    // Calculations for the overlapping layout
    final Size size = MediaQuery.of(context).size;
    final double imageHeight = size.height * 0.55; // Visible image area
    final double imageParallax =
        -(_sheetExtent - 0.55) * 140; // Move image up as sheet expands

    return Scaffold(
      backgroundColor: const Color(0xFFF8E8D4), // Soft peach background
      body: Stack(
        children: [
          // --- 1. Top Image Section ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeight,
            child: Transform.translate(
              offset: Offset(0, imageParallax),
              child: Hero(
                tag: 'pet_${pet.name}',
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8E8D4),
                    image: petImagePath != null
                        ? DecorationImage(
                            image: AssetImage(petImagePath),
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          )
                        : null,
                  ),
                  child: petImagePath == null
                      ? Center(
                          child: Icon(
                            isDog ? Icons.pets : Icons.pets_outlined,
                            size: 100,
                            color: colorScheme.primary.withValues(alpha: 0.6),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),

          // --- 2. Back Button ---
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // --- 3. Bottom Content as Draggable Sheet ---
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() => _sheetExtent = notification.extent);
              return false;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.55,
              maxChildSize: 0.92,
              snap: true,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    children: [
                      // --- Name Header ---
                      Center(
                        child: Column(
                          children: [
                            Text(
                              pet.name,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${pet.species} • ${pet.breed}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- Stats Row (Chips) ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _StatChip(
                            icon: Icons.cake,
                            label: 'Age',
                            value: pet.age,
                            color: const Color(0xFFFFE0B2), // Light Orange
                            iconColor: Colors.orange,
                          ),
                          _StatChip(
                            icon: Icons.category,
                            label: 'Breed',
                            value: pet.breed,
                            color: const Color(0xFFE1BEE7), // Light Purple
                            iconColor: Colors.purple,
                          ),
                          _StatChip(
                            icon: isDog ? Icons.pets : Icons.pets_outlined,
                            label: 'Species',
                            value: pet.species,
                            color: const Color(0xFFC8E6C9), // Light Green
                            iconColor: Colors.green,
                          ),
                        ],
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
                                    builder: (context) =>
                                        PetGalleryView(pet: pet),
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
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
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
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _InfoTile(
                        title: 'Last Scan',
                        subtitle: '3 days ago - Healthy',
                        icon: Icons.center_focus_strong,
                        iconBgColor: const Color(0xFFFF9F59), // Orange
                        isChecked: true,
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        title: 'Next Vaccination',
                        subtitle: '20 March 2026',
                        icon: Icons.medical_services,
                        iconBgColor: const Color(0xFF7165E3), // Purple
                        isChecked: false,
                      ),
                      const SizedBox(height: 12),
                      _InfoTile(
                        title: 'Notes',
                        subtitle: 'Allergies, food preferences...',
                        icon: Icons.sticky_note_2,
                        iconBgColor: colorScheme.secondary, // Aqua
                        isChecked: false,
                      ),

                      const SizedBox(height: 40),

                      // --- Remove Button ---
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () =>
                              viewModel.onConfirmRemovalPressed(context),
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

                      // Add extra padding at the bottom for scrolling comfort
                      const SizedBox(height: 30),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- Helper: Stat Chip ---
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color iconColor;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
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
