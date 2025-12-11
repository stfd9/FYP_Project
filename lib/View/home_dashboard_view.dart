import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/home_dashboard_view_model.dart';
import '../ViewModel/home_view_model.dart';
import 'notifications_view.dart';

class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Access HomeViewModel here BEFORE creating the inner provider
    final homeViewModel = context.read<HomeViewModel>();

    return ChangeNotifierProvider(
      create: (_) => HomeDashboardViewModel(),
      child: _HomeDashboardContent(homeViewModel: homeViewModel),
    );
  }
}

class _HomeDashboardContent extends StatelessWidget {
  const _HomeDashboardContent({required this.homeViewModel});

  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dashboardViewModel = context.watch<HomeDashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- Gradient Header with Overlapping Card ---
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Gradient curved background
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Decorative circles
                        Positioned(
                          top: -30,
                          right: -30,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: -40,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                        ),
                        // Header content
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Welcome back,',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: Colors.white.withValues(
                                            alpha: 0.85,
                                          ),
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'PetOwner 👋',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const NotificationsView(),
                                      ),
                                    );
                                  },
                                  icon: Stack(
                                    children: [
                                      const Icon(
                                        Icons.notifications_outlined,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Quick actions card
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: -55,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _QuickActionButton(
                            icon: Icons.center_focus_strong,
                            label: 'Scan',
                            gradient: const [
                              Color(0xFF667EEA),
                              Color(0xFF764BA2),
                            ],
                            onTap: homeViewModel.goToScanTab,
                          ),
                          _QuickActionButton(
                            icon: Icons.pets,
                            label: 'Add Pet',
                            gradient: const [
                              Color(0xFF11998E),
                              Color(0xFF38EF7D),
                            ],
                            onTap: () => dashboardViewModel.addPet(context),
                          ),
                          _QuickActionButton(
                            icon: Icons.calendar_month,
                            label: 'Calendar',
                            gradient: const [
                              Color(0xFFFF8008),
                              Color(0xFFFFC837),
                            ],
                            onTap: homeViewModel.goToCalendarTab,
                          ),
                          _QuickActionButton(
                            icon: Icons.history,
                            label: 'History',
                            gradient: const [
                              Color(0xFFEB3349),
                              Color(0xFFF45C43),
                            ],
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 70),

              // --- Main Content ---
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Upcoming Card ---
                    _SectionHeader(title: 'Upcoming', icon: Icons.event_note),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.08),
                            Colors.white,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.calendar_today_rounded,
                              color: colorScheme.primary,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "Today's Focus",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  dashboardViewModel.upcomingItem,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3142),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // --- Your Pets ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SectionHeader(title: 'Your Pets', icon: Icons.pets),
                        GestureDetector(
                          onTap: () => dashboardViewModel.openPetsList(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'View all',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 12,
                                  color: colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (dashboardViewModel.pets.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.pets,
                              size: 40,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No pets added yet',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () =>
                                  dashboardViewModel.addPet(context),
                              child: const Text('Add your first pet'),
                            ),
                          ],
                        ),
                      )
                    else
                      SizedBox(
                        height: 155,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dashboardViewModel.pets.length,
                          itemBuilder: (context, index) {
                            final pet = dashboardViewModel.pets[index];
                            final colors = _getPetCardColors(index);
                            return _PetHomeCard(pet: pet, colors: colors);
                          },
                        ),
                      ),

                    const SizedBox(height: 28),

                    // --- Health Tips ---
                    _SectionHeader(
                      title: 'Pet Care Tips',
                      icon: Icons.lightbulb_outline,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFF3E0), Color(0xFFFFFFFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.tips_and_updates,
                              color: Colors.orange,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Did you know?',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Regular grooming helps detect skin issues early!',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF2D3142),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // --- Recent Scans ---
                    _SectionHeader(title: 'Recent Scans', icon: Icons.history),
                    const SizedBox(height: 12),
                    if (dashboardViewModel.recentScans.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'No recent scans',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ),
                      )
                    else
                      ...dashboardViewModel.recentScans.asMap().entries.map(
                        (entry) => _RecentScanTile(
                          scan: entry.value,
                          index: entry.key,
                          onTap: () => dashboardViewModel.openScanDetail(
                            context,
                            entry.value,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getPetCardColors(int index) {
    final colorSets = [
      [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      [const Color(0xFF11998E), const Color(0xFF38EF7D)],
      [const Color(0xFFFF8008), const Color(0xFFFFC837)],
      [const Color(0xFFEB3349), const Color(0xFFF45C43)],
      [const Color(0xFF4568DC), const Color(0xFFB06AB3)],
    ];
    return colorSets[index % colorSets.length];
  }
}

// --- Section Header Widget ---
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF2D3142)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
      ],
    );
  }
}

// --- Quick Action Button Widget ---
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: gradient.first.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3142),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Pet Card Widget ---
class _PetHomeCard extends StatelessWidget {
  final PetHomeInfo pet;
  final List<Color> colors;

  const _PetHomeCard({required this.pet, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gradient header
          Container(
            height: 65,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.first.withValues(alpha: 0.8),
                  colors.last.withValues(alpha: 0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.pets, color: Colors.white, size: 28),
              ),
            ),
          ),
          // Info section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pet.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF2D3142),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colors.first.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      pet.species,
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.first,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Recent Scan Tile Widget ---
class _RecentScanTile extends StatelessWidget {
  final RecentScanInfo scan;
  final int index;
  final VoidCallback onTap;

  const _RecentScanTile({
    required this.scan,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isHealthy =
        scan.result.toLowerCase().contains('healthy') ||
        scan.result.toLowerCase().contains('normal');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF667EEA).withValues(alpha: 0.15),
                        const Color(0xFF764BA2).withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.document_scanner_outlined,
                    color: Color(0xFF667EEA),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scan.petName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isHealthy ? Colors.green : Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            scan.result,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            ' • ${scan.time}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
