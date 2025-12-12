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

  void deleteAccount(BuildContext context) {
    _showSnack(context, 'Account deletion flow coming soon.');
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
