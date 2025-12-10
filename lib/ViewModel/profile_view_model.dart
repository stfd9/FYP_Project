import 'package:flutter/material.dart';

import '../View/account_details_view.dart';
import '../View/feedback_view.dart';
import '../View/help_faq_view.dart';
import '../View/notification_settings_view.dart';
import '../View/privacy_security_view.dart';
import 'base_view_model.dart';

class ProfileViewModel extends BaseViewModel {
  final String userName = 'User Name';
  final String email = 'user@email.com';

  void editProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile editing coming soon.')),
    );
  }

  void openAccountDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AccountDetailsView()),
    );
  }

  void openNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationSettingsView()),
    );
  }

  void openPrivacySecurity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrivacySecurityView()),
    );
  }

  void openHelp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HelpFaqView()),
    );
  }

  void openFeedback(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FeedbackView()),
    );
  }

  void logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
