import 'package:flutter/material.dart';
import '../View/reset_password_view.dart';

class EnterOtpViewModel extends ChangeNotifier {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> verifyOtp(BuildContext context) async {
    errorMessage = null;
    notifyListeners();

    if (otpController.text.length < 4) {
      errorMessage = 'Please enter a valid 4-digit code.';
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    // Simulate API verification
    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    notifyListeners();

    if (context.mounted) {
      // Navigate to Reset Password Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResetPasswordView()),
      );
    }
  }

  void resendCode(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification code resent to your email.')),
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}
