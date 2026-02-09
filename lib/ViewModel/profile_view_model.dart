import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../View/account_details_view.dart';
import '../View/feedback_view.dart';
import '../View/help_faq_view.dart';
import '../View/notification_settings_view.dart';
import '../View/privacy_security_view.dart';
import 'base_view_model.dart';

class ProfileViewModel extends BaseViewModel {
  // --- State Variables ---
  String _userName = 'Loading...';
  String _email = '';
  String? _profileImageUrl; // To store the image URL
  int _totalPets = 0;
  int _totalScans = 0;
  int _daysActive = 0;

  // --- Getters ---
  String get userName => _userName;
  String get email => _email;
  String? get profileImageUrl => _profileImageUrl;
  int get totalPets => _totalPets;
  int get totalScans => _totalScans;
  int get daysActive => _daysActive;

  // --- Constructor ---
  ProfileViewModel() {
    _fetchUserProfile();
  }

  // --- Fetch Data Logic ---
  Future<void> _fetchUserProfile() async {
    final authUser = FirebaseAuth.instance.currentUser;

    if (authUser == null) {
      _userName = 'Guest';
      _email = 'No email';
      notifyListeners();
      return;
    }

    // 1. Set Email directly from Auth
    _email = authUser.email ?? 'No Email';

    // Calculate Days Active
    if (authUser.metadata.creationTime != null) {
      final difference = DateTime.now().difference(
        authUser.metadata.creationTime!,
      );
      _daysActive = difference.inDays;
    }

    try {
      // 2. Fetch User Details from Firestore
      final userSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('providerId', isEqualTo: authUser.uid)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final data = userSnapshot.docs.first.data();
        _userName = data['userName'] ?? 'User';
        _profileImageUrl = data['profileImageUrl']; // Fetch the image URL

        // Save the Custom User ID (e.g. U000001) for fetching pets
        final customUserId = userSnapshot.docs.first.id;

        // 3. Fetch Total Pets Count
        final petsSnapshot = await FirebaseFirestore.instance
            .collection('pets')
            .where('userId', isEqualTo: customUserId)
            .get();

        _totalPets = petsSnapshot.docs.length;
      }
    } catch (e) {
      print("Error fetching profile: $e");
      _userName = 'Error loading';
    }

    notifyListeners();
  }

  // --- Actions ---

  // When returning from Account Details, refresh the profile data
  // to show the new image if it changed.
  void onAccountDetailsPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AccountDetailsView()),
    ).then((_) => _fetchUserProfile()); // Refresh when coming back
  }

  void onNotificationsPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationSettingsView()),
    );
  }

  void onPrivacySecurityPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrivacySecurityView()),
    );
  }

  void onHelpPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HelpFaqView()),
    );
  }

  void onFeedbackPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FeedbackView()),
    );
  }

  // --- Logout Logic ---
  Future<void> onLogoutPressed(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error logging out: $e')));
    }
  }
}