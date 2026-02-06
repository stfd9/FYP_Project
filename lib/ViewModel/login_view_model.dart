import 'package:flutter/material.dart';

// Import your page views here
import '../View/home_view.dart';
import '../View/register_view.dart';
import '../View/admin_login_view.dart';
import '../View/forgot_password_view.dart'; // <--- Import this
import 'base_view_model.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isTermsAccepted = false;

  String? _message;
  MessageType? _messageType;

  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;
  bool get isTermsAccepted => _isTermsAccepted;
  String? get errorMessage => _message; // kept for backward compatibility
  String? get message => _message;
  MessageType? get messageType => _messageType;

  void setMessage(String? msg, [MessageType? type]) {
    _message = msg;
    _messageType = type;
    notifyListeners();
  }

  void clearMessage() {
    if (_message == null && _messageType == null) return;
    _message = null;
    _messageType = null;
    notifyListeners();
  }

  void onTogglePasswordPressed() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleTerms(bool? value) {
    _isTermsAccepted = value ?? false;
    notifyListeners();
  }

  // openTermsAndConditions moved to view layer to keep ViewModel UI-free

  Future<void> onLoginPressed(BuildContext context) async {
    setMessage(null, null);

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setMessage('Please provide both email and password.', MessageType.error);
      return;
    }

    debugPrint('🔵 Login button pressed');
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

  // --- UPDATED: Navigate to Forgot Password Page ---
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
