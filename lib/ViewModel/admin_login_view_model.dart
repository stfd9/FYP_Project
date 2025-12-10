import 'package:flutter/material.dart';
import 'base_view_model.dart'; // Assuming you reuse the same base class

class AdminLoginViewModel extends BaseViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> loginAdmin(BuildContext context) async {
    final validationError = _validateInputs();
    if (validationError != null) {
      setError(validationError);
      return;
    }

    // Logic specifically for Admin Login
    // You might call a different API endpoint here like authService.adminLogin()
    runAsync(() async {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Navigate to Admin Dashboard instead of Home
      // Ensure '/admin_dashboard' is defined in your routes
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/admin_dashboard');
      }
    });
  }

  String? _validateInputs() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return 'Please provide admin credentials.';
    }
    // You can add specific admin validation here (e.g., must contain @admin.com)
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
