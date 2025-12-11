import 'package:flutter/material.dart';

import 'base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;

  void onTogglePasswordPressed() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> onLoginPressed(BuildContext context) async {
    final validationError = _validateInputs();
    if (validationError != null) {
      setError(validationError);
      return;
    }

    runAsync(() async {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void onRegisterPressed(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  void onAdminLoginPressed(BuildContext context) {
    Navigator.pushNamed(context, '/admin_login');
  }

  void onForgotPasswordPressed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset flow coming soon.')),
    );
  }

  void onProviderPressed(BuildContext context, String providerName) {
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
