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

  void onEditProfilePressed(BuildContext context) {
    editProfile(context);
  }

  void editProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile editing coming soon.')),
    );
  }

  void onAccountDetailsPressed(BuildContext context) {
    openAccountDetails(context);
  }

  void openAccountDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AccountDetailsView()),
    );
  }

  void onNotificationsPressed(BuildContext context) {
    openNotifications(context);
  }

  void openNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationSettingsView()),
    );
  }

  void onPrivacySecurityPressed(BuildContext context) {
    openPrivacySecurity(context);
  }

  void openPrivacySecurity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrivacySecurityView()),
    );
  }

  void onHelpPressed(BuildContext context) {
    openHelp(context);
  }

  void openHelp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HelpFaqView()),
    );
  }

  void onFeedbackPressed(BuildContext context) {
    openFeedback(context);
  }

  void openFeedback(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FeedbackView()),
    );
  }

  void onLogoutPressed(BuildContext context) {
    logout(context);
  }

  void logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
