import 'package:flutter/material.dart';
import 'base_view_model.dart';

class AdminDashboardViewModel extends BaseViewModel {
  // -- Navigation Methods --

  void onManageAccountsPressed(BuildContext context) {
    navigateToManageAccounts(context);
  }

  void navigateToManageAccounts(BuildContext context) {
    Navigator.pushNamed(context, '/manage_accounts');
  }

  void onUserFeedbackPressed(BuildContext context) {
    navigateToUserFeedback(context);
  }

  void navigateToUserFeedback(BuildContext context) {
    Navigator.pushNamed(context, '/admin_feedback_list');
  }

  void onAnalysisRecordsPressed(BuildContext context) {
    navigateToAnalysisRecords(context);
  }

  void navigateToAnalysisRecords(BuildContext context) {
    // Navigate to Analysis History
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Analysis Records page coming soon.')),
    );
  }

  void onManageFaqPressed(BuildContext context) {
    navigateToManageFAQ(context);
  }

  void navigateToManageFAQ(BuildContext context) {
    // Navigate to FAQ Editor
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('FAQ Management page coming soon.')),
    );
  }

  void onLogoutPressed(BuildContext context) {
    logout(context);
  }

  void logout(BuildContext context) {
    // Navigate back to login and remove all previous routes
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
