import 'package:flutter/material.dart';

import 'base_view_model.dart';

class PrivacySecurityViewModel extends BaseViewModel {
  void onChangePasswordPressed(BuildContext context) {
    Navigator.pushNamed(context, '/change_password');
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
