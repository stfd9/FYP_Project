import 'dart:io'; // Required for File
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Required for Storage
import 'package:image_picker/image_picker.dart'; // Required for Picker
import 'base_view_model.dart';

class AccountDetailsViewModel extends BaseViewModel {
  // --- Controllers ---
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // --- State Variables ---
  bool _isLoading = false;
  String? _docId;
  String? _currentImageUrl; // URL currently in Firestore
  File? _selectedImage; // Image picked from Gallery (Waiting to upload)

  bool get isLoading => _isLoading;
  String? get currentImageUrl => _currentImageUrl;
  File? get selectedImage => _selectedImage;

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
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('providerId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();

        _docId = doc.id;
        userNameController.text = data['userName'] ?? '';
        nameController.text = data['fullName'] ?? '';
        emailController.text = data['userEmail'] ?? '';
        // Load the existing image URL if it exists
        _currentImageUrl = data['profileImageUrl'];
      }
    } catch (e) {
      print("Error loading account details: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- 2. Pick Image Logic ---
  Future<void> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    // Show dialog to choose Camera or Gallery (Optional, defaulting to Gallery here)
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Compress image to save storage/data
    );

    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners(); // Update UI to show the local preview
    }
  }

  // --- 3. Save Changes (Upload + Update) ---
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
      String? newImageUrl = _currentImageUrl;

      // A. Upload Image to Firebase Storage (if a new one was picked)
      if (_selectedImage != null) {
        // 1. Define the path: profile_images/U00001.jpg
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('$_docId.jpg');

        // 2. Upload file
        await storageRef.putFile(_selectedImage!);

        // 3. Get the Download URL
        newImageUrl = await storageRef.getDownloadURL();
      }

      // B. Update Firestore
      await FirebaseFirestore.instance.collection('user').doc(_docId).update({
        'userName': userNameController.text.trim(),
        'fullName': nameController.text.trim(),
        'userEmail': emailController.text.trim(),
        'profileImageUrl': newImageUrl, // Save the URL
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
