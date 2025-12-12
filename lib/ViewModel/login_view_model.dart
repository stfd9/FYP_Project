import 'package:flutter/material.dart';

// Import your page views here
import '../View/home_dashboard_view.dart';
import '../View/register_view.dart';
import '../View/admin_login_view.dart';
import '../View/forgot_password_view.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isTermsAccepted = false;
  String? _errorMessage;

  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;
  bool get isTermsAccepted => _isTermsAccepted;
  String? get errorMessage => _errorMessage;

  void onTogglePasswordPressed() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleTerms(bool? value) {
    _isTermsAccepted = value ?? false;
    notifyListeners();
  }

  // --- NEW: Open Terms Dialog ---
  void openTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          height: 300, // Limit height to make it scrollable
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '1. Introduction',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Welcome to PawScope. By using our app, you agree to these terms...',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 12),
                Text(
                  '2. User Data',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'We collect data regarding your pets to provide health insights. Your data is encrypted and secure...',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 12),
                Text(
                  '3. AI Disclaimer',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'The AI scanning tool is for reference only and does not replace professional veterinary advice...',
                  style: TextStyle(color: Colors.grey),
                ),
                // Add more dummy text as needed
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // User agrees via Dialog
              toggleTerms(true);
              Navigator.pop(context);
            },
            child: const Text('I Agree'),
          ),
        ],
      ),
    );
  }

  Future<void> onLoginPressed(BuildContext context) async {
    _errorMessage = null;
    notifyListeners();

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _errorMessage = 'Please provide both email and password.';
      notifyListeners();
      return;
    }

    if (!_isTermsAccepted) {
      _errorMessage = 'Please agree to the Terms and Conditions.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeDashboardView()),
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
