import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ViewModel/home_dashboard_view_model.dart';
import '../ViewModel/home_view_model.dart';
import 'notifications_view.dart';

class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeDashboardViewModel(),
      child: const _HomeDashboardContent(),
    );
  }
}

class _HomeDashboardContent extends StatelessWidget {
  const _HomeDashboardContent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dashboardViewModel = context.watch<HomeDashboardViewModel>();
    final homeViewModel = context.read<HomeViewModel>();

    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F6FA,
      ), // Light grey background like TNG
      body: Stack(
        children: [
          // 1. Blue Background Header (Curved)
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: colorScheme.primary, // Cobalt Blue
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
          ),

          // 2. Main Content (Scrollable)
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Top Bar (Greetings & Notification) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back,',
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              const Text(
                                'PetOwner', // You can replace with User Name
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsView(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- Floating "Quick Actions" Card (TNG Style) ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DashboardMenuIcon(
                          icon: Icons.center_focus_strong,
                          label: 'Scan',
                          color: colorScheme.primary,
                          onTap: homeViewModel.goToScanTab,
                        ),
                        _DashboardMenuIcon(
                          icon: Icons.pets,
                          label: 'Add Pet',
                          color: colorScheme.secondary,
                          onTap: () => dashboardViewModel.addPet(context),
                        ),
                        _DashboardMenuIcon(
                          icon: Icons.calendar_month,
                          label: 'Calendar',
                          color: Colors.orange,
                          onTap: homeViewModel.goToCalendarTab,
                        ),
                        _DashboardMenuIcon(
                          icon: Icons.article_outlined,
                          label: 'Records',
                          color: Colors.purple,
                          onTap: () {
                            // Navigate to records if you have a tab
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- "Today's Schedule" (Highlighted Card) ---
                  Text(
                    'Upcoming',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFE3F2FD), // Light Blue
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.blue.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            color: colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today's Focus",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dashboardViewModel.upcomingItem,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- Your Pets (Horizontal List) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Pets',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => dashboardViewModel.openPetsList(context),
                        child: Text(
                          'View all',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (dashboardViewModel.pets.isEmpty)
                    const Text('No pets added yet.')
                  else
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dashboardViewModel.pets.length,
                        itemBuilder: (context, index) {
                          final pet = dashboardViewModel.pets[index];
                          return _PetHomeCard(pet: pet);
                        },
                      ),
                    ),

                  const SizedBox(height: 24),

                  // --- Recent Scans (Vertical List) ---
                  Text(
                    'Recent Scans',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...dashboardViewModel.recentScans.map(
                    (scan) => _RecentScanTile(
                      scan: scan,
                      onTap: () =>
                          dashboardViewModel.openScanDetail(context, scan),
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

// --- NEW WIDGET: Dashboard Menu Icon (Like TNG) ---
class _DashboardMenuIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DashboardMenuIcon({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// --- EXISTING WIDGET: Pet Card (Styled) ---
class _PetHomeCard extends StatelessWidget {
  final PetHomeInfo pet;

  const _PetHomeCard({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade100,
            child: Icon(Icons.pets, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 12),
          Text(
            pet.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            pet.species,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

// --- EXISTING WIDGET: Recent Scan Tile (Styled) ---
class _RecentScanTile extends StatelessWidget {
  final RecentScanInfo scan;
  final VoidCallback onTap;

  const _RecentScanTile({required this.scan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.center_focus_strong,
            color: Colors.blue.shade700,
            size: 20,
          ),
        ),
        title: Text(
          scan.petName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          '${scan.result} • ${scan.time}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
