import 'package:flutter/material.dart';
import '../View/enter_otp_view.dart'; // Import the OTP View

class ForgotPasswordViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  // --- Logic to Send Code ---
  Future<void> sendResetLink(BuildContext context) async {
    // 1. Reset Error
    errorMessage = null;
    notifyListeners();

    // 2. Input Validation
    final email = emailController.text.trim();
    if (email.isEmpty) {
      errorMessage = 'Please enter your email address.';
      notifyListeners();
      return;
    }

    // Simple Regex for Email Validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errorMessage = 'Please enter a valid email address.';
      notifyListeners();
      return;
    }

    // 3. Simulate API Call (Loading State)
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    isLoading = false;
    notifyListeners();

    // 4. Navigate to OTP Page
    if (context.mounted) {
      // Show a small feedback message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification code sent to $email'),
          duration: const Duration(seconds: 2),
        ),
      );

      // Push the Enter OTP View
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EnterOtpView()),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
