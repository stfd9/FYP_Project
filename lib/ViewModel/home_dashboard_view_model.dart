import 'dart:async'; // <--- Import for Timer
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../View/add_pet_view.dart';
import '../View/notifications_view.dart';
import 'base_view_model.dart';

class HomeDashboardViewModel extends BaseViewModel {
  final PageController tipPageController = PageController();
  Timer? _timer; // <--- Timer for auto-scrolling

  // --- State Variables ---
  List<PetHomeInfo> _pets = [];
  List<CommunityTip> _randomTips = [];
  final String _upcomingItem = 'No upcoming events today';
  bool _isLoading = true;

  // --- Getters ---
  List<PetHomeInfo> get pets => List.unmodifiable(_pets);
  List<CommunityTip> get randomTips => List.unmodifiable(_randomTips);
  String get upcomingItem => _upcomingItem;
  bool get isLoading => _isLoading;

  HomeDashboardViewModel() {
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([_fetchUserPets(), _fetchRandomTips()]);

    _isLoading = false;
    notifyListeners();
  }

  // --- 1. Fetch 5 Random Tips ---
  Future<void> _fetchRandomTips() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('community_tips')
          .get();

      if (snapshot.docs.isNotEmpty) {
        final allTips = snapshot.docs
            .map((doc) => CommunityTip.fromFirestore(doc))
            .toList();

        allTips.shuffle(Random());
        _randomTips = allTips.take(5).toList();

        // Start auto-scrolling only if we have tips
        if (_randomTips.isNotEmpty) {
          _startAutoScroll();
        }
      }
    } catch (e) {
      print("Error fetching random tips: $e");
    }
  }

  // --- AUTO SCROLL LOGIC ---
  void _startAutoScroll() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      // 3 seconds is better for readability than 2
      if (_randomTips.isEmpty || !tipPageController.hasClients) return;

      int nextPage = (tipPageController.page?.round() ?? 0) + 1;

      if (nextPage >= _randomTips.length) {
        nextPage = 0; // Loop back to start
      }

      tipPageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  // --- 2. Fetch User Pets ---
  Future<void> _fetchUserPets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .where('providerId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final customUserId = userDoc.docs.first.id;

        final petsSnapshot = await FirebaseFirestore.instance
            .collection('pets')
            .where('userId', isEqualTo: customUserId)
            .get();

        _pets = petsSnapshot.docs.map((doc) {
          final data = doc.data();
          String ageString = '2Y'; // Placeholder
          if (data['birthDate'] != null) {
            // Calculate age logic here
          }

          return PetHomeInfo(
            name: data['petName'] ?? 'Unknown',
            species: data['petSpecies'] ?? 'Pet',
            lastScan: 'No scans yet',
            age: ageString,
          );
        }).toList();
      }
    } catch (e) {
      print("Error fetching pets: $e");
    }
  }

  // --- Navigation Actions ---
  void openNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsView()),
    );
  }

  void addPet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPetView()),
    ).then((_) => _loadDashboardData());
  }

  void openPetsList(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Go to "Pets" tab to view all.')),
    );
  }

  void openCalendar(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Go to "Calendar" tab.')));
  }

  @override
  void dispose() {
    _timer?.cancel(); // <--- Important: Stop timer when leaving screen
    tipPageController.dispose();
    super.dispose();
  }
}

// --- Data Models ---

class PetHomeInfo {
  final String name;
  final String species;
  final String lastScan;
  final String age;

  const PetHomeInfo({
    required this.name,
    required this.species,
    required this.lastScan,
    this.age = '',
  });
}

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

  factory CommunityTip.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommunityTip(
      id: doc.id,
      category: data['tipsCategory'] ?? 'General',
      title: data['tipsTitle'] ?? '',
      description: data['tipsDesc'] ?? '',
    );
  }
}
