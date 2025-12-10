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
    final args = ModalRoute.of(context)?.settings.arguments;

    int initialIndex = 0;
    DateTime? calendarDate;

    // --- SAFE ARGUMENT PARSING ---
    if (args is int) {
      // If we just passed a number (e.g. 1)
      initialIndex = args;
    } else if (args is Map) {
      // If we passed complex data (e.g. {'tab': 1, 'date': ...})
      if (args['tab'] is int) initialIndex = args['tab'];
      if (args['date'] is DateTime) calendarDate = args['date'];
    }

    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = HomeViewModel();
        if (initialIndex != 0) {
          viewModel.setInitialTab(initialIndex);
        }
        return viewModel;
      },
      // Pass the date down to the Scaffold
      child: _HomeScaffold(initialCalendarDate: calendarDate),
    );
  }
}

class _HomeScaffold extends StatelessWidget {
  final DateTime? initialCalendarDate;

  const _HomeScaffold({this.initialCalendarDate});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    final pages = [
      const HomeDashboardView(),
      // Pass the date explicitly to CalendarView
      CalendarView(initialDate: initialCalendarDate),
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
