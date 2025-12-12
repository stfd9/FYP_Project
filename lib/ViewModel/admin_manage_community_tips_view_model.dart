import 'package:flutter/material.dart';

class CommunityTip {
  final String id;
  final String category;
  final String title;
  final String description;

  CommunityTip({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
  });
}

class AdminManageCommunityTipsViewModel extends ChangeNotifier {
  final List<CommunityTip> _tips = [
    CommunityTip(
      id: '1',
      category: 'Hydration',
      title: 'Keep Your Pet Hydrated',
      description:
          'Ensure fresh water is always available. Dogs need 1 ounce per pound of body weight daily.',
    ),
    CommunityTip(
      id: '2',
      category: 'Exercise',
      title: 'Daily Exercise Routine',
      description:
          'Regular exercise prevents obesity and behavioral issues. Aim for 30-60 minutes daily.',
    ),
    CommunityTip(
      id: '3',
      category: 'Health Check',
      title: 'Regular Vet Visits',
      description:
          'Schedule check-ups every 6-12 months. Early detection saves lives and reduces costs.',
    ),
    CommunityTip(
      id: '4',
      category: 'Grooming',
      title: 'Dental Care Matters',
      description:
          'Brush your pet\'s teeth 2-3 times weekly. Poor dental health affects overall well-being.',
    ),
    CommunityTip(
      id: '5',
      category: 'Nutrition',
      title: 'Quality Food Matters',
      description:
          'Choose age-appropriate, high-quality food. Avoid human foods like chocolate and grapes.',
    ),
  ];

  List<CommunityTip> get tips => List.unmodifiable(_tips);

  void addNewTip(BuildContext context) {
    _showTipDialog(context);
  }

  void editTip(BuildContext context, CommunityTip tip) {
    _showTipDialog(context, existingTip: tip);
  }

  void deleteTip(BuildContext context, CommunityTip tip) {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Delete Tip'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${tip.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _tips.removeWhere((t) => t.id == tip.id);
              notifyListeners();
              Navigator.of(ctx, rootNavigator: true).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tip deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showTipDialog(BuildContext context, {CommunityTip? existingTip}) {
    final isEditing = existingTip != null;
    final titleController = TextEditingController(
      text: existingTip?.title ?? '',
    );
    final descriptionController = TextEditingController(
      text: existingTip?.description ?? '',
    );

    final categories = [
      'Hydration',
      'Exercise',
      'Health Check',
      'Grooming',
      'Nutrition',
      'Safety',
      'Training',
      'General',
    ];

    final categoryColors = {
      'Hydration': const Color(0xFF00ACC1),
      'Exercise': const Color(0xFFFF9800),
      'Health Check': const Color(0xFFE91E63),
      'Grooming': const Color(0xFF9C27B0),
      'Nutrition': const Color(0xFF4CAF50),
      'Safety': const Color(0xFFF44336),
      'Training': const Color(0xFF3F51B5),
      'General': const Color(0xFF607D8B),
    };

    final categoryIcons = {
      'Hydration': Icons.water_drop_rounded,
      'Exercise': Icons.directions_run_rounded,
      'Health Check': Icons.health_and_safety_rounded,
      'Grooming': Icons.content_cut_rounded,
      'Nutrition': Icons.restaurant_rounded,
      'Safety': Icons.shield_rounded,
      'Training': Icons.psychology_rounded,
      'General': Icons.lightbulb_rounded,
    };

    String selectedCategory = existingTip?.category ?? categories.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final selectedColor =
              categoryColors[selectedCategory] ?? const Color(0xFF9C27B0);
          final selectedIcon =
              categoryIcons[selectedCategory] ?? Icons.lightbulb_rounded;

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // --- Gradient Header with Drag Handle ---
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            selectedColor,
                            selectedColor.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(28),
                          topRight: Radius.circular(28),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                      child: Column(
                        children: [
                          // Drag handle
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          // Icon and title
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  selectedIcon,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isEditing ? 'Edit Tip' : 'Add New Tip',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isEditing
                                          ? 'Update your community tip'
                                          : 'Share helpful advice with the community',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withValues(
                                          alpha: 0.85,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // --- Form Content ---
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 24,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category selector
                          const Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: selectedColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selectedColor.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedCategory,
                                isExpanded: true,
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: selectedColor.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: selectedColor,
                                    size: 20,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                items: categories.map((cat) {
                                  final color =
                                      categoryColors[cat] ??
                                      const Color(0xFF9C27B0);
                                  final icon =
                                      categoryIcons[cat] ??
                                      Icons.lightbulb_rounded;
                                  return DropdownMenuItem<String>(
                                    value: cat,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: color.withValues(
                                              alpha: 0.12,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Icon(
                                            icon,
                                            color: color,
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          cat,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() => selectedCategory = newValue);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Title field
                          const Text(
                            'Title',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                hintText: 'Enter tip title...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    right: 8,
                                  ),
                                  child: Icon(
                                    Icons.title_rounded,
                                    color: Colors.grey.shade400,
                                    size: 22,
                                  ),
                                ),
                              ),
                              maxLines: 2,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Description field
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: TextField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                hintText: 'Share your helpful tip...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    right: 8,
                                    bottom: 60,
                                  ),
                                  child: Icon(
                                    Icons.description_outlined,
                                    color: Colors.grey.shade400,
                                    size: 22,
                                  ),
                                ),
                              ),
                              maxLines: 4,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 28),
                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(ctx),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    if (titleController.text.trim().isEmpty ||
                                        descriptionController.text
                                            .trim()
                                            .isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please fill in all fields',
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    if (isEditing) {
                                      final index = _tips.indexWhere(
                                        (t) => t.id == existingTip.id,
                                      );
                                      if (index != -1) {
                                        _tips[index] = CommunityTip(
                                          id: existingTip.id,
                                          category: selectedCategory,
                                          title: titleController.text.trim(),
                                          description: descriptionController
                                              .text
                                              .trim(),
                                        );
                                      }
                                    } else {
                                      _tips.add(
                                        CommunityTip(
                                          id: DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          category: selectedCategory,
                                          title: titleController.text.trim(),
                                          description: descriptionController
                                              .text
                                              .trim(),
                                        ),
                                      );
                                    }

                                    notifyListeners();
                                    Navigator.pop(ctx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isEditing
                                              ? 'Tip updated successfully'
                                              : 'Tip added successfully',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          selectedColor,
                                          selectedColor.withValues(alpha: 0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: selectedColor.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          isEditing
                                              ? Icons.check_rounded
                                              : Icons.add_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          isEditing
                                              ? 'Save Changes'
                                              : 'Add Tip',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ], // Column children
                ), // Column
              ), // SingleChildScrollView
            ), // Container
          ); // GestureDetector
        },
      ),
    );
  }
}
