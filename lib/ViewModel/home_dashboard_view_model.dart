import 'package:flutter/material.dart';

import '../View/add_pet_view.dart';
import 'base_view_model.dart';

class HomeDashboardViewModel extends BaseViewModel {
  final List<PetHomeInfo> _pets = const [
    PetHomeInfo(name: 'Milo', species: 'Dog', lastScan: '3 days ago'),
    PetHomeInfo(name: 'Luna', species: 'Cat', lastScan: '1 week ago'),
  ];

  final List<RecentScanInfo> _recentScans = const [
    RecentScanInfo(
      petName: 'Milo',
      result: 'No visible skin issue',
      time: 'Today • 10:15 AM',
    ),
    RecentScanInfo(
      petName: 'Luna',
      result: 'Mild redness detected',
      time: '2 days ago',
    ),
  ];

  final String upcomingItem = 'Vaccination for Milo at 4:00 PM';

  List<PetHomeInfo> get pets => List.unmodifiable(_pets);

  List<RecentScanInfo> get recentScans => List.unmodifiable(_recentScans);

  void openNotifications(BuildContext context) {
    _showSnack(context, 'Notifications screen coming soon.');
  }

  void openCalendar(BuildContext context) {
    _showSnack(context, 'Calendar shortcut tapped.');
  }

  void addPet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPetView()),
    );
  }

  void openPetsList(BuildContext context) {
    _showSnack(context, 'Navigate to all pets.');
  }

  void openScanDetail(BuildContext context, RecentScanInfo scan) {
    _showSnack(context, 'Viewing ${scan.petName}\'s scan.');
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class PetHomeInfo {
  final String name;
  final String species;
  final String lastScan;

  const PetHomeInfo({
    required this.name,
    required this.species,
    required this.lastScan,
  });
}

class RecentScanInfo {
  final String petName;
  final String result;
  final String time;

  const RecentScanInfo({
    required this.petName,
    required this.result,
    required this.time,
  });
}
