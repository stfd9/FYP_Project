import 'package:flutter/material.dart';

import 'base_view_model.dart';

class PrivacySecurityViewModel extends BaseViewModel {
  void changePassword(BuildContext context) {
    _showSnack(context, 'Change password flow coming soon.');
  }

  void manageSessions(BuildContext context) {
    _showSnack(context, 'Login session management coming soon.');
  }

  void openPrivacyPolicy(BuildContext context) {
    _showSnack(context, 'Privacy policy will open here.');
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
