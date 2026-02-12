import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../View/add_pet_view.dart';
import '../View/notifications_view.dart';
import 'base_view_model.dart';

class HomeDashboardViewModel extends BaseViewModel {
  final PageController tipPageController = PageController();
  Timer? _timer;

  // --- State Variables ---
  List<PetHomeInfo> _pets = [];
  List<CommunityTip> _randomTips = [];
  final String _upcomingItem = 'No upcoming events today';
  bool _isLoading = true;

  // --- Getters ---
  List<PetHomeInfo> get pets => List.unmodifiable(_pets);
  List<CommunityTip> get randomTips => List.unmodifiable(_randomTips);
  String get upcomingItem => _upcomingItem;
  @override
  bool get isLoading => _isLoading;

  HomeDashboardViewModel() {
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      _fetchUserPets(), // Updated logic
      _fetchRandomTips(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  // --- 1. Fetch User Pets (Mirroring PetProfileViewModel logic) ---
  Future<void> _fetchUserPets() async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) return;

    try {
      // Step A: Resolve Custom User ID (U0000X)
      // The pets are stored under the custom user ID, NOT the Auth UID.
      final userSnap = await FirebaseFirestore.instance
          .collection('user')
          .where('providerId', isEqualTo: authUser.uid)
          .limit(1)
          .get();

      if (userSnap.docs.isEmpty) return;
      final customUserId = userSnap.docs.first.id;

      // Step B: Load Breeds Map (ID -> Name) to display "Golden Retriever" instead of "Dog"
      final breedSnap = await FirebaseFirestore.instance
          .collection('breed')
          .get();
      final Map<String, String> breedMap = {
        for (final doc in breedSnap.docs)
          doc.id: (doc.data()['breedName'] as String?) ?? '',
      };

      // Step C: Query 'pet' collection (singular)
      final petsSnap = await FirebaseFirestore.instance
          .collection('pet')
          .where('userId', isEqualTo: customUserId)
          .get();

      // Step D: Map data to UI Model
      _pets = petsSnap.docs.map((doc) {
        final data = doc.data();

        // 1. Calculate Age
        String ageString = 'N/A';
        if (data['dateOfBirth'] != null) {
          // Correct field name: 'dateOfBirth'
          try {
            DateTime dob;
            if (data['dateOfBirth'] is Timestamp) {
              dob = (data['dateOfBirth'] as Timestamp).toDate();
            } else {
              dob = DateTime.parse(data['dateOfBirth'].toString());
            }
            ageString = _calculateAge(dob);
          } catch (e) {
            print("Error parsing date: $e");
          }
        }

        // 2. Determine Display Species (Breed Name)
        // If we have a breedId, use the breed name. Otherwise fallback to species or "Pet".
        String displaySubtitle = data['species'] ?? 'Pet';
        final breedId = data['breedId'] as String?;
        if (breedId != null && breedMap.containsKey(breedId)) {
          displaySubtitle = breedMap[breedId]!;
        }

        return PetHomeInfo(
          name: data['petName'] ?? 'Unknown', // Correct field name: 'petName'
          species: displaySubtitle,
          lastScan: 'No scans yet',
          age: ageString,
        );
      }).toList();
    } catch (e) {
      print("Error fetching pets: $e");
    }
  }

  // Helper: Calculate Age (e.g., 2Y, 5M)
  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    final days = difference.inDays;

    if (days >= 365) {
      return '${(days / 365).floor()}Y'; // Years
    } else if (days >= 30) {
      return '${(days / 30).floor()}M'; // Months
    } else {
      return '${days}D'; // Days
    }
  }

  // --- 2. Fetch Random Tips (Existing Logic) ---
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

        if (_randomTips.isNotEmpty) {
          _startAutoScroll();
        }
      }
    } catch (e) {
      print("Error fetching random tips: $e");
    }
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_randomTips.isEmpty || !tipPageController.hasClients) return;
      int nextPage = (tipPageController.page?.round() ?? 0) + 1;
      if (nextPage >= _randomTips.length) nextPage = 0;

      tipPageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
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
    ).then((_) => _loadDashboardData()); // Refresh list when returning
  }

  void openPetsList(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Go to "Pets" tab to view details.')),
    );
  }

  void goToScanTab() {
    // Implement navigation to Scan tab
  }

  void goToCalendarTab() {
    // Implement navigation to Calendar tab
  }

  @override
  void dispose() {
    _timer?.cancel();
    tipPageController.dispose();
    super.dispose();
  }
}

// --- Data Models (Internal) ---

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
