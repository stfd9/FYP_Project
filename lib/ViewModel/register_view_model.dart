import 'package:flutter/material.dart';

import 'base_view_model.dart';

class RegisterViewModel extends BaseViewModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  void onTogglePasswordPressed() {
    togglePasswordVisibility();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void onToggleConfirmPressed() {
    toggleConfirmVisibility();
  }

  void toggleConfirmVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  Future<void> onRegisterPressed(BuildContext context) async {
    await register(context);
  }

  Future<void> register(BuildContext context) async {
    final validationError = _validateInputs();
    if (validationError != null) {
      setError(validationError);
      return;
    }

    runAsync(() async {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  void onGoToLoginPressed(BuildContext context) {
    goToLogin(context);
  }

  void goToLogin(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  String? _validateInputs() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return 'All fields are required.';
    }
    if (passwordController.text.length < 6) {
      return 'Password should be at least 6 characters long.';
    }
    if (passwordController.text != confirmPasswordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
