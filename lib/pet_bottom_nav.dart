import 'package:flutter/material.dart';

/// Reusable bottom navigation bar with a center Scan action.
class PetBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onScanPressed;

  const PetBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onScanPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 96,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // background bar
              Positioned.fill(
                top: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _NavIconButton(
                        icon: Icons.home_outlined,
                        label: 'Home',
                        isActive: currentIndex == 0,
                        onTap: () => onTabSelected(0),
                      ),
                      _NavIconButton(
                        icon: Icons.calendar_today_outlined,
                        label: 'Calendar',
                        isActive: currentIndex == 1,
                        onTap: () => onTabSelected(1),
                      ),
                      const SizedBox(width: 64),
                      _NavIconButton(
                        icon: Icons.pets_outlined,
                        label: 'Pets',
                        isActive: currentIndex == 3,
                        onTap: () => onTabSelected(3),
                      ),
                      _NavIconButton(
                        icon: Icons.person_outline,
                        label: 'Profile',
                        isActive: currentIndex == 4,
                        onTap: () => onTabSelected(4),
                      ),
                    ],
                  ),
                ),
              ), // center scan button with custom icon
              Positioned(
                top: -6,
                child: GestureDetector(
                  onTap: onScanPressed,
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 6, 15, 176),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.35),
                          blurRadius: 26,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'images/assets/logo.png',
                        fit: BoxFit.contain, // no color override
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavIconButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color color = isActive
        ? const Color.fromARGB(255, 6, 15, 176)
        : colorScheme.onSurface.withValues(alpha: 0.55);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final ViewModel viewModel;
  final List<Widget> pages;

  const MyHomePage({super.key, required this.viewModel, required this.pages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          final offsetAnimation =
              Tween<Offset>(
                begin: const Offset(1.0, 0.0), // slide in from right
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

          return SlideTransition(position: offsetAnimation, child: child);
        },
        child: KeyedSubtree(
          key: ValueKey(viewModel.selectedIndex),
          child: pages[viewModel.selectedIndex],
        ),
      ),
      bottomNavigationBar: PetBottomNavBar(
        currentIndex: viewModel.selectedIndex,
        onTabSelected: viewModel.selectTab,
        onScanPressed: viewModel.goToScanTab,
      ),
    );
  }
}

class ViewModel {
  int selectedIndex = 0;

  void selectTab(int index) {
    selectedIndex = index;
    // Notify listeners or update the UI
  }

  void goToScanTab() {
    selectedIndex = 2; // Assuming the scan tab index is 2
    // Notify listeners or update the UI
  }
}
