import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_view_model.dart';

class AccountDetailsViewModel extends BaseViewModel {
  // --- Controllers ---
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController nameController =
      TextEditingController(); // For Full Name
  final TextEditingController emailController = TextEditingController();

  // --- State Variables ---
  bool _isLoading = false;
  String? _docId; // To store the Firestore Document ID (e.g., U00001)

  bool get isLoading => _isLoading;

  // --- Constructor ---
  AccountDetailsViewModel() {
    _loadUserData();
  }

  // --- 1. Load User Data ---
  Future<void> _loadUserData() async {
    _isLoading = true;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      // Find the user document in Firestore based on Auth UID
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('providerId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();

        _docId = doc.id; // Save ID for updating later

        // Populate Controllers
        userNameController.text = data['userName'] ?? '';
        nameController.text =
            data['fullName'] ?? ''; // Assuming 'fullName' key exists
        emailController.text = data['userEmail'] ?? '';
      }
    } catch (e) {
      print("Error loading account details: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- 2. Save Changes ---
  void onSaveChangesPressed(BuildContext context) {
    if (_docId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User profile not found.')),
      );
      return;
    }

    _updateUserProfile(context);
  }

  Future<void> _updateUserProfile(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Update Firestore
      await FirebaseFirestore.instance.collection('user').doc(_docId).update({
        'userName': userNameController.text.trim(),
        'fullName': nameController.text.trim(),
        'userEmail': emailController.text.trim(),
        // Note: We are NOT updating the Firebase Auth email here to avoid re-authentication flows.
        // We are only updating the database record.
      });

      _isLoading = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
      }
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
