import 'package:flutter/material.dart';
import 'base_view_model.dart';

class AdminDashboardViewModel extends BaseViewModel {
  // -- Manage Accounts --
  void onManageAccountsPressed(BuildContext context) {
    Navigator.pushNamed(context, '/manage_accounts');
  }

  // -- Analysis Records --
  void onAnalysisRecordsPressed(BuildContext context) {
    Navigator.pushNamed(context, '/analysis_records');
  }

  // -- User Feedback --
  void onUserFeedbackPressed(BuildContext context) {
    Navigator.pushNamed(context, '/admin_feedback_list');
  }

  // -- Manage FAQ --
  void onManageFaqPressed(BuildContext context) {
    Navigator.pushNamed(context, '/manage_faq');
  }

  // -- Manage Community Tips --
  void onManageCommunityTipsPressed(BuildContext context) {
    Navigator.pushNamed(context, '/manage_community_tips');
  }

  // -- Logout --
  void onLogoutPressed(BuildContext context) {
    // Navigate back to login and remove all previous routes
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
