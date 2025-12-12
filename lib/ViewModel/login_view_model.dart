import 'package:flutter/material.dart';

// Import your page views here
import '../View/home_view.dart';
import '../View/register_view.dart';
import '../View/admin_login_view.dart';
import '../View/forgot_password_view.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  // --- NEW: Terms & Conditions State ---
  bool _isTermsAccepted = false;

  String? _errorMessage;

  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;

  // --- NEW: Getter for Terms State ---
  bool get isTermsAccepted => _isTermsAccepted;

  String? get errorMessage => _errorMessage;

  void onTogglePasswordPressed() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // --- NEW: Toggle Terms Logic ---
  void toggleTerms(bool? value) {
    _isTermsAccepted = value ?? false;
    notifyListeners();
  }

  Future<void> onLoginPressed(BuildContext context) async {
    _errorMessage = null;
    notifyListeners();

    // 1. Input Validation
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _errorMessage = 'Please provide both email and password.';
      notifyListeners();
      return;
    }

    // 2. Terms Validation (NEW)
    if (!_isTermsAccepted) {
      _errorMessage = 'Please agree to the Terms and Conditions.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    }
  }

  void onRegisterPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterView()),
    );
  }

  void onAdminLoginPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminLoginView()),
    );
  }

  void onForgotPasswordPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordView()),
    );
  }

  void onProviderPressed(BuildContext context, String providerName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$providerName sign-in coming soon.')),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
