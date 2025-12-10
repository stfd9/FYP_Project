import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pet_bottom_nav.dart';
import '../View/calendar_view.dart';
import '../View/pet_profile_view.dart';
import '../View/profile_view.dart';
import '../View/scan_view.dart';
import '../ViewModel/home_view_model.dart';
import 'home_dashboard_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const _HomeScaffold(),
    );
  }
}

class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    final pages = [
      const HomeDashboardView(),
      const CalendarView(),
      const ScanView(),
      const PetProfileView(),
      const ProfileView(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          );
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
