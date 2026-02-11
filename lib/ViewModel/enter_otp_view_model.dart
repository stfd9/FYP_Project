import 'package:flutter/material.dart';
import '../services/otp_service.dart';
import '../View/reset_password_view.dart';

class EnterOtpViewModel extends ChangeNotifier {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  late String _email;

  // Getter for the View to access private _email
  String get email => _email;

  void initialize(String email) {
    _email = email;
  }

  Future<void> verifyOtp(BuildContext context) async {
    errorMessage = null;
    notifyListeners();

    if (otpController.text.length < 6) {
      errorMessage = 'Please enter the valid 6-digit code.';
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    // --- FIX 1: Use the Service Instance ---
    // We use the shared instance that already knows the generated code
    bool isValid = OtpService.auth.verifyOTP(otp: otpController.text.trim());

    isLoading = false;
    notifyListeners();

    if (isValid) {
      if (context.mounted) {
        // Success: Go to Reset Password
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResetPasswordView(email: _email)),
        );
      }
    } else {
      errorMessage = 'Invalid OTP code. Please try again.';
      notifyListeners();
    }
  }

  Future<void> resendCode(BuildContext context) async {
    // --- FIX 2: Re-configure and Send without arguments ---
    OtpService.configure(email: _email);

    // sendOTP() typically returns Future<bool>, so we await it
    bool sent = await OtpService.auth.sendOTP();

    if (context.mounted) {
      if (sent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New code sent to your email.')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to resend code.')));
      }
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}
