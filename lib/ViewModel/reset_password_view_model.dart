import 'package:flutter/material.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscureNew = true;
  bool obscureConfirm = true;
  bool isLoading = false;
  String? errorMessage;

  void toggleNewVisibility() {
    obscureNew = !obscureNew;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    obscureConfirm = !obscureConfirm;
    notifyListeners();
  }

  Future<void> resetPassword(BuildContext context) async {
    errorMessage = null;
    notifyListeners();

    if (newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      errorMessage = 'Please enter all fields.';
      notifyListeners();
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      errorMessage = 'Passwords do not match.';
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    notifyListeners();

    if (context.mounted) {
      // Pop all the way back to Login
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully! Please login.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
