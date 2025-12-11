import 'package:flutter/material.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  // Text Controllers
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  // Visibility States (to toggle the "eye" icon)
  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  bool isLoading = false;

  // --- Toggles for Password Visibility ---
  void toggleCurrentVisibility() {
    obscureCurrent = !obscureCurrent;
    notifyListeners();
  }

  void toggleNewVisibility() {
    obscureNew = !obscureNew;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    obscureConfirm = !obscureConfirm;
    notifyListeners();
  }

  // --- Logic to Update Password ---
  Future<void> updatePassword(BuildContext context) async {
    // 1. Basic Validation
    if (currentPassController.text.isEmpty ||
        newPassController.text.isEmpty ||
        confirmPassController.text.isEmpty) {
      _showSnackBar(context, 'Please fill in all fields.', isError: true);
      return;
    }

    if (newPassController.text != confirmPassController.text) {
      _showSnackBar(context, 'New passwords do not match.', isError: true);
      return;
    }

    if (newPassController.text.length < 6) {
      _showSnackBar(
        context,
        'Password must be at least 6 characters.',
        isError: true,
      );
      return;
    }

    // 2. Simulate Loading / API Call
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    isLoading = false;
    notifyListeners();

    // 3. Success Feedback & Navigation
    if (context.mounted) {
      _showSnackBar(context, 'Password updated successfully!');
      Navigator.pop(context); // Go back to previous screen
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }
}
