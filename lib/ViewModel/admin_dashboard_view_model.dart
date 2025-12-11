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
    Navigator.pushNamed(context, '/analysis_records');
  }

  void onManageFaqPressed(BuildContext context) {
    navigateToManageFAQ(context);
  }

  void navigateToManageFAQ(BuildContext context) {
    Navigator.pushNamed(context, '/manage_faq');
  }

  void onLogoutPressed(BuildContext context) {
    logout(context);
  }

  void logout(BuildContext context) {
    // Navigate back to login and remove all previous routes
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
