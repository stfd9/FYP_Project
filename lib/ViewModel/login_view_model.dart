import 'package:flutter/material.dart';

import 'base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    final validationError = _validateInputs();
    if (validationError != null) {
      setError(validationError);
      return;
    }

    runAsync(() async {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void goToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  // --- NEW METHOD FOR ADMIN NAV ---
  void goToAdminLogin(BuildContext context) {
    // Ensure you have defined '/admin_login' in your main.dart routes
    Navigator.pushNamed(context, '/admin_login');
  }
  // --------------------------------

  void forgotPassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset flow coming soon.')),
    );
  }

  void continueWithProvider(BuildContext context, String providerName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$providerName sign-in coming soon.')),
    );
  }

  String? _validateInputs() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return 'Please provide both email and password.';
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
