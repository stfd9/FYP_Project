import 'package:flutter/material.dart';

import 'base_view_model.dart';
// --- FIX: Import the View here ---
import '../View/privacy_policy_view.dart';

class PrivacySecurityViewModel extends BaseViewModel {
  void onChangePasswordPressed(BuildContext context) {
    Navigator.pushNamed(context, '/change_password');
  }

  void manageSessions(BuildContext context) {
    _showSnack(context, 'Login session management coming soon.');
  }

  void openPrivacyPolicy(BuildContext context) {
    // --- Now this works because we imported the class above ---
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrivacyPolicyView()),
    );
  }

  // Account deletion removed from in-app settings; keep for backwards compatibility
  // or future admin functionality. Currently it shows a helpful message.
  void deleteAccount(BuildContext context) {
    _showSnack(
      context,
      'Account deletion is handled via support. Please contact support for assistance.',
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
